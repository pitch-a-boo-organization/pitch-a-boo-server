import Foundation
import Network

class PitchABooWebSocketServer {
    var listener: NWListener
    var connectedClients: [NWConnection] = []
    var timer: Timer?
        
    init(port: UInt16) throws {
        let parameters = NWParameters(tls: nil)
        parameters.allowLocalEndpointReuse = true
        parameters.includePeerToPeer = true

        let wsOptions = NWProtocolWebSocket.Options()
        wsOptions.autoReplyPing = true

        parameters.defaultProtocolStack.applicationProtocols.insert(wsOptions, at: 0)

        do {
            if let port = NWEndpoint.Port(rawValue: port) {
                listener = try NWListener(using: parameters, on: port)
            } else {
                throw WebSocketError.unableToStartInPort(port)
            }
        } catch {
            throw WebSocketError.unableToInitializeListener
        }
    }
    
    func getDeviceHostname() -> String? {
        let processInfo = ProcessInfo()
        return processInfo.hostName
    }
    
    func sendMessageToClient(
        data: Data,
        client: NWConnection,
        completion: @escaping (WebSocketError?) -> Void
    ) {
        let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
        let context = NWConnection.ContentContext(identifier: "context", metadata: [metadata])
        
        client.send(
            content: data,
            contentContext: context,
            isComplete: true,
            completion: .contentProcessed( { error in
                if let _ = error {
                    completion(.unableToSendAMessageToUser)
                } else {
                    completion(nil)
                }
        }))
    }
}

// MARK: - Server Connection Handler
extension PitchABooWebSocketServer {
    func startServer(completion: @escaping (WebSocketError?) -> Void ) {
        print("Starting Server...")
        let serverQueue = DispatchQueue(label: "ServerQueue")
        
        listener.newConnectionHandler = { newConnection in
            self.didReceiveAConnection(newConnection, completion: completion)
            self.didUpdateConnectionState(newConnection, completion: completion)
            newConnection.start(queue: serverQueue)
        }
        
        listener.stateUpdateHandler = { state in
            switch state {
                case .ready:
                    completion(nil)
                case .failed(let error):
                    completion(.serverInitializationFail(error.localizedDescription))
                default:
                    break
            }
        }
            
        listener.start(queue: serverQueue)
        print("Server Started")
        //Debug: startTimer()
    }
}

// MARK: - Client Connection Handler
extension PitchABooWebSocketServer {
    private func didReceiveAConnection(
        _ connection: NWConnection,
        completion: @escaping (WebSocketError?) -> Void
    ) {
        connection.receiveMessage { [weak self] (data, context, isComplete, error) in
            if let data = data, let context = context {
                do {
                    try self?.handleMessageFromClient(
                        data: data,
                        context: context,
                        stringVal: "",
                        connection: connection
                    )
                } catch {
                    completion(.cantHandleClientMessage)
                }
                self?.didReceiveAConnection(connection, completion: completion)
            }
        }
    }

    private func didUpdateConnectionState(
        _ connection: NWConnection,
        completion: @escaping (WebSocketError?) -> Void
    ) {
        print("UPDATING CONNECTION STATE")
        connection.stateUpdateHandler = { state in
            switch state {
                case .ready:
                    let data = try! JSONEncoder().encode(
                        TransferMessage(
                            type: .connection,
                            message: "connected"
                        )
                    )
                    self.sendMessageToClient(data: data, client: connection, completion: completion)
                case .failed(_):
                    completion(.cantConnectWithClient)
                case .waiting(_):
                    completion(.connectTimeWasTooLong)
                default:
                    break
            }
        }
    }
    
    func handleMessageFromClient(data: Data, context: NWConnection.ContentContext, stringVal: String, connection: NWConnection) throws {
        if let message = try? JSONDecoder().decode(TransferMessage.self, from: data)  {
            switch message.type {
                case .connection:
                    if message.message == "subscribe" {
                        self.connectedClients.append(connection)
                    }
                case .count:
                    break
            }
        }
    }
}

// MARK: - Debug
extension PitchABooWebSocketServer {
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            guard !self.connectedClients.isEmpty else {
                return
            }
            let data = try! JSONEncoder().encode(
                TransferMessage(
                    type: .count,
                    message: "\(Int.random(in: 0...100))"
                )
            )
            for (index, client) in self.connectedClients.enumerated() {
                print("Sending message to client number \(index)")
                self.sendMessageToClient(data: data, client: client) { error in
                    if let error = error {
                        print(error)
                    }
                }
            }
        })
        timer?.fire()
    }
}

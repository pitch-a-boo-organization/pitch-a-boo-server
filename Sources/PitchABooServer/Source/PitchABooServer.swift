import Foundation
import Network

public final class PitchABooWebSocketServer: ObservableObject, Server {
    @Published var gameSession: GameSession = GameSession()
    var connectedClients: [Connection] = []
    var listener: NWListener
    var timer: Timer?
    private var router: ServerRouter = ServerRouter()
    
    public init(port: UInt16) throws {
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
        router.server = self
    }
    
    func getServerState() -> NWListener.State {
        return listener.state
    }
    
    public func getServerHostname() -> String? {
        let processInfo = ProcessInfo()
        return processInfo.hostName
    }
    
    internal func sendMessageToClient(
        message: TransferMessage,
        client: Connection,
        completion: @escaping (WebSocketError?) -> Void
    ) {
        let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
        let context = NWConnection.ContentContext(identifier: "context", metadata: [metadata])
        
        do {
            let messageData = try message.encodeToTransfer()
            client.send(
                content: messageData,
                contentContext: context,
                isComplete: true,
                completion: .contentProcessed( { error in
                    if let _ = error {
                        completion(.unableToSendAMessageToUser)
                    } else {
                        completion(nil)
                    }
            }))
            completion(nil)
        } catch {
            completion(.unableToEncodeMessage)
        }
    }
    
    internal func sendMessageToAllClients(_ message: TransferMessage) {
        for connectedClient in connectedClients {
            sendMessageToClient(
                message: message,
                client: connectedClient,
                completion: { error in
                    if let error = error {
                        print("\(#function) - Erro: \(error.localizedDescription)")
                    }
                }
            )
        }
    }
}

// MARK: - Server Connection Handler
extension PitchABooWebSocketServer {
    public func startServer(completion: @escaping (WebSocketError?) -> Void ) {
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
                    self.sendMessageToClient(
                        message: DefaultMessage.canConnectMessage(!self.gameSession.gameHasStarted).load,
                        client: connection,
                        completion: completion
                    )
                case .failed(_):
                    completion(.cantConnectWithClient)
                case .waiting(_):
                    completion(.connectTimeWasTooLong)
                default:
                    break
            }
        }
    }
    
    func handleMessageFromClient(
        data: Data,
        context: NWConnection.ContentContext,
        connection: Connection
    ) throws {
        if let message = try? JSONDecoder().decode(TransferMessage.self, from: data) {
            router.redirectMessage(message, from: connection)
        }
    }
}

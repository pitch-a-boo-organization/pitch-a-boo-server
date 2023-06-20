//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation
import Network

public class ServerRouter {
    weak var server: PitchABooWebSocketServer?
    public init(server: PitchABooWebSocketServer? = nil) { self.server = server }
    
    func redirectMessage(
        _ message: TransferMessage,
        from connection: NWConnection
    ) {
        guard let code = CommandCode.ClientMessage(rawValue: message.code) else { return }
        guard let server = server else { return }
        switch code {
            case .verifyAvailability:
                let message = DefaultMessage.canConnectMessage(server.listener.state == .ready).load
                server.sendMessageToClient(
                    message: message,
                    client: connection,
                    completion: { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                )
            case .connectToSession:
                if server.players.count < 4 {
                    server.connectedClients.append(connection)
                    if !Item.availableItems.isEmpty {
                        guard let playerItem = Item.availableItems.first else { return }
                        server.players.append(
                            Player(
                                id: server.players.count + 1,
                                name: "Id \(server.players.count + 1)",
                                bones: 0,
                                sellingItem: playerItem,
                                persona: Persona.availablePersonas[server.players.count]
                            )
                        )
                        Item.availableItems.removeFirst()
                    }
                }
                let message = DefaultMessage.connectedPlayers(server.players).load
                server.sendMessageToClient(
                    message: message,
                    client: connection,
                    completion: { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                )
            case .bid:
                break
            case .startProcess:
                break
        }
    }
}
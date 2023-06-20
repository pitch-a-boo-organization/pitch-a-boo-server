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
        switch message.code {
            case .connectionAvailability:
                let message = DefaultMessage.canConnectMessage(server?.listener.state == .ready).load
                server?.sendMessageToClient(
                    message: message,
                    client: connection,
                    completion: { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                )
            case .availabilityStatus:
                break
            case .connectToSession:
                server?.connectedClients.append(connection)
                let message = DefaultMessage.connectMessage(server?.listener.state == .ready).load
                server?.sendMessageToClient(
                    message: message,
                    client: connection,
                    completion: { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    })
            case .connectionStatus:
                break
            case .startGame:
                break
            case .bid:
                break
            case .connectedPlayers:
                break
            case .selectedPlayer:
                break
            case .saleResult:
                break
        }
    }
}

//
//  File.swift
//  
//
//  Created by Thiago Henrique on 22/06/23.
//

import Foundation
import Network

protocol Server: AnyObject {
    var connectedClients: [Connection] { get set }
    var gameSession: GameSession { get set }
    var output: ServerOutputs? { get set }
    
    func sendMessageToClient(
        message: TransferMessage,
        client: Connection,
        completion: @escaping (WebSocketError?) -> Void
    )
    func getServerHostname() -> String?
    func getServerState() -> NWListener.State
    func sendMessageToAllClients(_ message: TransferMessage)
    func startServer(completion: @escaping (WebSocketError?) -> Void )
    func handleMessageFromClient(data: Data, context: NWConnection.ContentContext, connection: Connection) throws 
}

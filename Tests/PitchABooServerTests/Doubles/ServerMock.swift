//
//  File.swift
//  
//
//  Created by Thiago Henrique on 22/06/23.
//

import Foundation
import Network
@testable import PitchABooServer

class ServerMock: Server {
    var connectedClients: [PitchABooServer.Connection] = []
    
    var gameSession: PitchABooServer.GameSession = GameSession()
    
    func sendMessageToClient(message: PitchABooServer.TransferMessage, client: PitchABooServer.Connection, completion: @escaping (PitchABooServer.WebSocketError?) -> Void) {
        
    }
    
    func getServerHostname() -> String? {
        return nil
    }
    
    func getServerState() -> NWListener.State {
        return NWListener.State.ready
    }
    
    func sendMessageToAllClients(_ message: PitchABooServer.TransferMessage) {
        
    }
    
    func startServer(completion: @escaping (PitchABooServer.WebSocketError?) -> Void) {
        
    }
    
    func handleMessageFromClient(data: Data, context: NWConnection.ContentContext, connection: PitchABooServer.Connection) throws {
        
    }
}

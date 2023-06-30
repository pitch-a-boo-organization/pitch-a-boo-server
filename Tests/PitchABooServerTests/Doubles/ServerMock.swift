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
    var output: PitchABooServer.ServerOutputs?
    
    private(set) var sendMessageToClientCalled = 0
    private(set) var getServerHostnameCalled = 0
    private(set) var getServerStateCalled = 0
    private(set) var sendMessageToAllClientsCalled = 0
    private(set) var startServerCalled = 0
    private(set) var handleMessageFromClientCalled = 0
    private(set) var sendedMessageToAllClients: TransferMessage?
    
    var connectedClients: [any Connection] = []
    var gameSession: GameSession = GameSession()
    
    func sendMessageToClient(
        message: PitchABooServer.TransferMessage,
        client: any PitchABooServer.Connection,
        completion: @escaping (PitchABooServer.WebSocketError?) -> Void) {
            sendMessageToClientCalled += 1
    }
    
    func getServerHostname() -> String? {
        getServerHostnameCalled += 1
        return nil
    }
    
    func getServerState() -> NWListener.State {
        getServerStateCalled += 1
        return NWListener.State.ready
    }
    
    func sendMessageToAllClients(_ message: PitchABooServer.TransferMessage) {
        sendMessageToAllClientsCalled += 1
        sendedMessageToAllClients = message
    }
    
    func startServer(completion: @escaping (PitchABooServer.WebSocketError?) -> Void) {
        startServerCalled += 1
    }
    
    func handleMessageFromClient(data: Data, context: NWConnection.ContentContext, connection: any PitchABooServer.Connection) throws {
        handleMessageFromClientCalled += 1
    }
}

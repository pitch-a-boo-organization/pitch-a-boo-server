//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

enum CommandCode: Codable {
    case client(ClientMessage)
    case server(ServerMessage)
    
    enum ClientMessage: Int, Codable {
        case verifyAvailability = 0
        case connectToSession = 2
        case bid = 5
        case startProcess = 4
        case pauseSession = 10
        case resumeSession = 11
        case updatePlayer = 12
    }
    
    enum ServerMessage: Int, Codable {
        case availabilityStatus = 1
        case connectionStatus = 3
        case startProcess = 4
        case connectedPlayers = 6
        case choosenPlayer = 7
        case saleResult = 8
        case playerIdentifier = 9
    }
}


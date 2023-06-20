//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

enum DefaultMessage {
    case canConnectMessage(Bool)
    case connectMessage(Bool)
    case availableMessage(Bool)
    case startMessage(Int, Bool)
    case connectedPlayers([Player])
    
    var load: TransferMessage {
        switch self {
        case .connectMessage(let connected):
            return connectionStatusMessage(connection: connected)
        case .startMessage(let stage, let start):
            return startGameMessage(stage: stage, start: start)
        case .availableMessage(let available):
            return availableMessage(available: available)
        case .canConnectMessage(let canConnect):
            return canConnectMessage(canConnect: canConnect)
        case .connectedPlayers(let players):
            return connectedPlayersMessage(players: players)
        }
    }
}

extension DefaultMessage {
    func startGameMessage(stage: Int, start: Bool) -> TransferMessage {
        TransferMessage(
            code: .startGame,
            device: .coreOS,
            message: try! JSONEncoder().encode(
                DTOStartProcess(
                    stage: stage,
                    start: start
                )
            )
        )
    }
    
    func connectionStatusMessage(connection: Bool) -> TransferMessage {
        return TransferMessage(
            code: .connectionStatus,
            device: .coreOS,
            message: try! JSONSerialization.data(
                withJSONObject:
                    """
                    {
                        "stage": 10,
                        "connected": \(connection)
                    }
                    """
            )
        )
    }
    
    func availableMessage(available: Bool) -> TransferMessage {
        return TransferMessage(
            code: .availabilityStatus,
            device: .coreOS,
            message: try! JSONEncoder().encode(
                DTOVerifyAvailability(
                    stage: 10,
                    available: true
                )
            )
        )
    }
    
    func canConnectMessage(canConnect: Bool) -> TransferMessage {
        return TransferMessage(
            code: .availabilityStatus,
            device: .coreOS,
            message: try! JSONSerialization.data(
                withJSONObject:
                    """
                    {
                        "stage": 10,
                        "canConnect": \(canConnect)
                    }
                    """
            )
        )
    }
    
    func connectedPlayersMessage(players: [Player]) -> TransferMessage {
        return TransferMessage(
            code: .connectedPlayers,
            device: .coreOS,
            message: try! JSONSerialization.data(
                withJSONObject:
                    """
                    {
                        "stage": 10,
                        "players": \(players)
                    }
                    """
            )
            
        )
    }
}

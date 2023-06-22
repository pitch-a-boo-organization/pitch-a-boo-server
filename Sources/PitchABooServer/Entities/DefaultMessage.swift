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
    case startMessage(Int, Bool)
    case connectedPlayers([Player])
    case playerIdentifier(Player)
    case choosePlayer(Int, Player, Item)
    
    var load: TransferMessage {
        switch self {
        case .connectMessage(let connected):
            return connectionStatusMessage(connection: connected)
        case .startMessage(let stage, let start):
            return startGameMessage(stage: stage, start: start)
        case .canConnectMessage(let canConnect):
            return canConnectMessage(canConnect: canConnect)
        case .connectedPlayers(let players):
            return connectedPlayersMessage(players: players)
        case .playerIdentifier(let player):
            return playerIdentifier(player: player)
        case .choosePlayer(let stage, let player, let item):
            return choosePlayer(stage: stage, player: player, item: item)
        }
    }
}

extension DefaultMessage {
    func startGameMessage(stage: Int, start: Bool) -> TransferMessage {
        TransferMessage(
            code: CommandCode.ServerMessage.startProcess.rawValue,
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
            code: CommandCode.ServerMessage.connectionStatus.rawValue,
            device: .coreOS,
            message: try! JSONEncoder().encode(
                DTOConnectStatus(
                    stage: 10,
                    connected: connection
                )
            )
        )
    }
    
    func canConnectMessage(canConnect: Bool) -> TransferMessage {
        return TransferMessage(
            code: CommandCode.ServerMessage.availabilityStatus.rawValue,
            device: .coreOS,
            message: try! JSONEncoder().encode(
                DTOStatusAvailability(
                    stage: 10,
                    canConnect: canConnect
                )
            )
        )
    }
    
    func connectedPlayersMessage(players: [Player]) -> TransferMessage {
        return TransferMessage(
            code: CommandCode.ServerMessage.connectedPlayers.rawValue,
            device: .coreOS,
            message: try! JSONEncoder().encode(
                DTOPlayersConnected(
                    stage: 10,
                    players: players
                )
            )
        )
    }
    
    func playerIdentifier(player: Player) -> TransferMessage {
        return TransferMessage(
            code: CommandCode.ServerMessage.playerIdentifier.rawValue,
            device: .coreOS,
            message: try! JSONEncoder().encode(
                DTOPlayerIdentifier(
                    stage: 10,
                    player: player
                )
            )
        )
    }
    
    func choosePlayer(stage: Int, player: Player, item: Item) -> TransferMessage {
        return TransferMessage(
            code: CommandCode.ServerMessage.choosenPlayer.rawValue,
            device: .coreOS,
            message: try! JSONEncoder().encode(
                DTOChosenPlayer(stage: stage, player: player, item: item)
            )
        )
    }
}

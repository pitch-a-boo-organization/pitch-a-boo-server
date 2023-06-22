//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation
import Network

class ServerRouter {
    weak var server: Server?
    init(server: Server? = nil) { self.server = server }
    
    func redirectMessage(_ message: TransferMessage, from connection: Connection) {
        guard let code = CommandCode.ClientMessage(rawValue: message.code) else { return }
        guard let server = server else { return }
        let session = server.gameSession
        
        switch code {
            case .verifyAvailability:
                let message = DefaultMessage.canConnectMessage(server.getServerState() == .ready).load
                server.sendMessageToClient(
                    message: message,
                    client: connection,
                    completion: { error in
                        if let error = error {
                            print("\(#function) - Erro: \(error.localizedDescription)")
                        }
                    }
                )
            case .connectToSession:
                if session.players.count < 7 {
                    server.connectedClients.append(connection)
                    let playerId = session.players.count
                    let player = Player(
                        id: playerId + 1,
                        name: Player.availableNames[playerId],
                        bones: 0,
                        sellingItem: Item.availableItems[playerId],
                        persona: Persona.availablePersonas[playerId]
                    )
                    server.gameSession.players.append(player)
                    server.sendMessageToClient(
                        message: DefaultMessage.playerIdentifier(player).load,
                        client: connection,
                        completion: { _ in }
                    )
                    server.sendMessageToAllClients(DefaultMessage.connectedPlayers(session.players).load)
                }
            case .bid:
                break
            case .startProcess:
                let startProcessDTO = try! JSONDecoder().decode(DTOStartProcess.self, from: message.message)
                guard let gameStage = GameStages(rawValue: startProcessDTO.stage) else { return }
                if startProcessDTO.start { handleStartInStage(gameStage) }
                break
        }
    }
    
    func handleStartInStage(_ stage: GameStages) {
        guard let server = server else { return }
        switch stage {
            case .first:
                break
            case .second:
                break
            case .firstRoundStage:
                server.gameSession.startGame()
                guard let sellingPlayer = server.gameSession.chooseSellingPlayer() else { return }
                server.sendMessageToAllClients(
                    DefaultMessage.choosePlayer(
                        stage.rawValue,
                        sellingPlayer,
                        sellingPlayer.sellingItem
                    ).load
                )
                break
            case .secondRoundStage:
                break
            case .thirdRoundStage:
                break
            case .fourthRoundStage:
                break
            case .fiftyRoundStage:
                break
        }
    }
}

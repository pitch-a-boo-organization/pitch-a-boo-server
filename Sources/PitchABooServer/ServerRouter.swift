//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation
import Network

public class ServerRouter {
    weak var server: (any Server)?
    init(server: (any Server)? = nil) { self.server = server }
    
    public func redirectMessage(_ message: TransferMessage, from connection: any Connection) {
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
                        bones: 10,
                        sellingItem: Item.availableItems[playerId],
                        persona: Persona.availablePersonas[playerId]
                    )
                    server.gameSession.players.append(player)
                    server.output?.didConectPlayer(players: server.gameSession.players)
                    server.sendMessageToClient(
                        message: DefaultMessage.playerIdentifier(player).load,
                        client: connection,
                        completion: { _ in }
                    )
                    server.sendMessageToAllClients(DefaultMessage.connectedPlayers(session.players).load)
                }
            case .bid:
                guard let bidMessage = try? JSONDecoder().decode(DTOBid.self, from: message.message) else {
                    print("Unrecognize Bid")
                    return
                }
                session.receive(bid: bidMessage.bid, from: bidMessage.player, finishBids: {})
                server.output?.didReceiveBid(bid: bidMessage.bid, from: bidMessage.player)
                break
            case .startProcess:
                let startProcessDTO = try! JSONDecoder().decode(DTOStartProcess.self, from: message.message)
                guard let gameStage = GameStages(rawValue: startProcessDTO.stage) else { return }
                if startProcessDTO.start { handleStartInStage(gameStage) }
                break
            case .pauseSession:
                let pauseMessage = try! JSONDecoder().decode(DTOPauseSession.self, from: message.message)
                    guard let playerIndex = session.players.firstIndex(where: { $0.id == pauseMessage.player.id}) else { return }
                    session.pausedPlayers.append(pauseMessage.player)
                case .resumeSession:
                    let resumeMessage = try! JSONDecoder().decode(DTOPauseSession.self, from: message.message)
                    if let playerIndex = session.pausedPlayers.firstIndex(where: { $0.id == resumeMessage.player.id}) {
                        server.connectedClients.append(connection)
                        session.pausedPlayers.remove(at: playerIndex)
                    }
                
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
                server.output?.didDefineSellingPlayer(sellingPlayer)
                server.sendMessageToAllClients(
                    DefaultMessage.choosePlayer(
                        stage.rawValue,
                        sellingPlayer,
                        sellingPlayer.sellingItem
                    ).load
                )
                server.sendMessageToAllClients(
                    DefaultMessage.startMessage(
                        31,
                        true
                    ).load
                )
                break
            case .secondRoundStage:
                break
            case .thirdRoundStage:
                server.sendMessageToAllClients(
                    DefaultMessage.startMessage(
                        33,
                        true
                    ).load
                )
            case .fourthRoundStage:
                server.sendMessageToAllClients(
                    DefaultMessage.startMessage(
                        34,
                        true
                    ).load
                )
                break
            case .fiftyRoundStage:
                guard let saleResult = server.gameSession.finishInning() else { return }
                let players = server.gameSession.players
                let gameEnded = server.gameSession.gameEnded
                server.output?.inningEnd(players: players, gameEnded: gameEnded, result: saleResult)
                server.sendMessageToAllClients(
                    DefaultMessage.saleResult(
                        players,
                        gameEnded,
                        saleResult
                    ).load
                )
                server.sendMessageToAllClients(
                    DefaultMessage.startMessage(
                        35,
                        true
                    ).load
                )
                break
        }
    }
}

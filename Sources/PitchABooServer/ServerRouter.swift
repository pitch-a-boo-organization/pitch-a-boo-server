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
        let session = server.gameSession
        switch code {
            case .verifyAvailability:
                let message = DefaultMessage.canConnectMessage(server.listener.state == .ready).load
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
                if session.players.count < 4 {
                    server.connectedClients.append(connection)
                    if !Item.availableItems.isEmpty {
                        guard let playerItem = Item.availableItems.first else { return }
                        let player = Player(
                            id: session.players.count + 1,
                            name: "Player \(session.players.count + 1)",
                            bones: 0,
                            sellingItem: playerItem,
                            persona: Persona.availablePersonas[session.players.count]
                        )
                        server.gameSession.players.append(player)
                        server.sendMessageToClient(
                            message: DefaultMessage.playerIdentifier(player).load,
                            client: connection,
                            completion: { _ in }
                        )
                        Item.availableItems.removeFirst()
                    }
                }
                server.sendMessageToAllClients(DefaultMessage.connectedPlayers(session.players).load)
            case .bid:
                break
            case .startProcess:
                let startProcessDTO = try! JSONDecoder().decode(DTOStartProcess.self, from: message.message)
                guard let gameStage = GameStages(rawValue: startProcessDTO.stage) else { return }
                handleStage(gameStage)
                break
        }
    }
    
    func handleStage(_ stage: GameStages) {
        guard let server = server else { return }
        switch stage {
            case .first:
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
            case .second:
                break
            case .firstRoundStage:
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

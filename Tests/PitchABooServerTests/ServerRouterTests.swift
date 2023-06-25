import XCTest
import Network
@testable import PitchABooServer

final class ServerRouterTests: XCTestCase {
    func test_redirectMessage_verifyAvailability_should_call_server_correctly() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputMessage = TransferMessage(
            code: CommandCode.ClientMessage.verifyAvailability.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOVerifyAvailability(stage: 10, available: true))
        )
        sut.redirectMessage(inputMessage, from: connection)
        XCTAssertEqual(server.sendMessageToClientCalled, 1)
    }
    
    func test_redirectMessage_connectToSession_should_append_connection_correctly() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputMessage = TransferMessage(
            code: CommandCode.ClientMessage.connectToSession.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOConnectSession(stage: 10, subscribe: true))
        )
        sut.redirectMessage(inputMessage, from: connection)
        XCTAssertEqual(server.connectedClients.count, 1)
    }
    
    func test_redirectMessage_connectToSession_should_append_player_on_gameSession() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputMessage = TransferMessage(
            code: CommandCode.ClientMessage.connectToSession.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOConnectSession(stage: 10, subscribe: true))
        )
        sut.redirectMessage(inputMessage, from: connection)
        XCTAssertEqual(server.gameSession.players.count, 1)
    }
    
    func test_redirectMessage_connectToSession_should_send_message_to_client() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputMessage = TransferMessage(
            code: CommandCode.ClientMessage.connectToSession.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOConnectSession(stage: 10, subscribe: true))
        )
        sut.redirectMessage(inputMessage, from: connection)
        XCTAssertEqual(server.sendMessageToClientCalled, 1)
    }
    
    func test_redirectMessage_connectToSession_should_send_message_to_all_clients() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputMessage = TransferMessage(
            code: CommandCode.ClientMessage.connectToSession.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOConnectSession(stage: 10, subscribe: true))
        )
        sut.redirectMessage(inputMessage, from: connection)
        XCTAssertEqual(server.sendMessageToAllClientsCalled, 1)
    }
    
    func test_redirectMessage_startProccess_firstRoundStage_should_start_game_if_start_true() throws {
        let (sut, (server, connection)) = makeSUT()
        sendStartProcessForSut(sut, connection: connection, stage: 31, start: true)
        XCTAssertEqual(server.gameSession.gameHasStarted, true)
    }
    
    func test_redirectMessage_startProccess_firstRoundStage_shouldnt_start_game_if_start_false() throws {
        let (sut, (server, connection)) = makeSUT()
        sendStartProcessForSut(sut, connection: connection, stage: 31, start: false)
        XCTAssertEqual(server.gameSession.gameHasStarted, false)
    }
    
    func test_redirectMessage_startProccess_firstRoundStage_should_send_chooseSellingPlayer_to_clients() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputPlayer = Player(
            id: 0,
            name: Player.availableNames.first!,
            bones: 0,
            sellingItem: Item.availableItems.first!,
            persona: Persona.availablePersonas.first!
        )
        server.gameSession.players.append(inputPlayer)
        sendStartProcessForSut(sut, connection: connection, stage: 31, start: true)
        XCTAssertNotNil(server.sendedMessageToAllClients)
        XCTAssertEqual(server.sendMessageToAllClientsCalled, 1)
    }
    
    func test_redirectMessage_startProcess_firstRoundStage_should_increase_sellers_on_gameSeller() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputPlayer = Player(
            id: 0,
            name: Player.availableNames.first!,
            bones: 0,
            sellingItem: Item.availableItems.first!,
            persona: Persona.availablePersonas.first!
        )
        server.gameSession.players.append(inputPlayer)
        sendStartProcessForSut(sut, connection: connection, stage: 31, start: true)
        XCTAssertEqual(server.gameSession.hasSelling.count, 1)
    }
    
    func test_redirectMessage_bid_session_should_receive_bid() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputPlayer = Player(
            id: 0,
            name: Player.availableNames.first!,
            bones: 0,
            sellingItem: Item.availableItems.first!,
            persona: Persona.availablePersonas.first!
        )
        server.gameSession.players.append(inputPlayer)
        let inputBidMessage = TransferMessage(
            code: CommandCode.ClientMessage.bid.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOBid(stage: 33, bid: 5, player: inputPlayer))
        )
        sut.redirectMessage(inputBidMessage, from: connection)
        XCTAssertEqual(server.gameSession.inningBids.count, 1)
    }
    
    func test_redirectMessage_startProcess_when_receive_return_saleResult_correctly() throws {
        let (sut, (server, connection)) = makeSUT()
        startGameWithPlayers(server, numOfPlayers: 5)
        let bids: [(player: Player, bid: Int)] = generateBidForPlayers(
            server.gameSession.players,
            sellingPlayer: server.gameSession.chooseSellingPlayer()!
        )
        let expectedOutput = bids.max(by: { $0.bid > $1.bid })
        sendBidsForSut(sut, bids: bids, connection: connection)
        sendFinishInningMessageForSut(sut, connection: connection)
        
        let sendedMessage = server.sendedMessageToAllClients
        XCTAssertNotNil(sendedMessage)
        let saleResult = try! JSONDecoder().decode(DTOSaleResult.self, from: sendedMessage!.message)
        XCTAssertEqual(saleResult.result.soldValue, expectedOutput!.bid)
    }
    
    func test_redirectMessage_should_not_end_game_when_has_sellers_left() throws {
        let (sut, (server, connection)) = makeSUT()
        startGameWithPlayers(server, numOfPlayers: 5)
        let bids: [(player: Player, bid: Int)] = generateBidForPlayers(
            server.gameSession.players,
            sellingPlayer: server.gameSession.chooseSellingPlayer()!
        )
        sendBidsForSut(sut, bids: bids, connection: connection)
        sendFinishInningMessageForSut(sut, connection: connection)
        XCTAssertFalse(server.gameSession.gameEnded)
    }
    
    func test_redirectMessage_should_restart_game_when_has_sellers_left() throws {
        let (sut, (server, connection)) = makeSUT()
        startGameWithPlayers(server, numOfPlayers: 5)
        let bids: [(player: Player, bid: Int)] = generateBidForPlayers(
            server.gameSession.players,
            sellingPlayer: server.gameSession.chooseSellingPlayer()!
        )
        sendBidsForSut(sut, bids: bids, connection: connection)
        sendStartProcessForSut(sut, connection: connection, stage: 31, start: true)
        XCTAssertNotNil(server.sendedMessageToAllClients)
    }
    
    func test_redirectMessage_startProcess_should_endGame_when_no_sellers_left() throws {
        let (sut, (server, connection)) = makeSUT()
        startGameWithPlayers(server, numOfPlayers: 5)

        for i in 0..<server.gameSession.players.count {
            sendStartProcessForSut(sut, connection: connection, stage: 31, start: true)
            XCTAssertEqual(server.gameSession.hasSelling.count, i + 1)
            sendStartProcessForSut(sut, connection: connection, stage: 32, start: true)
            sendStartProcessForSut(sut, connection: connection, stage: 33, start: true)
            
            let bids: [(player: Player, bid: Int)] = generateBidForPlayers(
                server.gameSession.players,
                sellingPlayer: server.gameSession.currentSellingPlayer!
            )
            
            sendBidsForSut(sut, bids: bids, connection: connection)
            sendStartProcessForSut(sut, connection: connection, stage: 34, start: true)
            sendStartProcessForSut(sut, connection: connection, stage: 35, start: true)
        }
        
        XCTAssertTrue(server.gameSession.gameEnded)
    }
    
}

// MARK: - Func Factory
extension ServerRouterTests {
    typealias Bid = (player: Player, bid: Int)
    func startGameWithPlayers(_ game: any Server, numOfPlayers: Int = 3) {
        if numOfPlayers > 7 { return }
        for i in 0..<numOfPlayers {
            let inputPlayer = Player(
                id: i,
                name: Player.availableNames[i],
                bones: Int.random(in: 1...10),
                sellingItem: Item.availableItems[i],
                persona: Persona.availablePersonas[i]
            )
            game.gameSession.players.append(inputPlayer)
        }
    }
    
    func sendStartProcessForSut(_ sut: ServerRouter, connection: Connection, stage: Int, start: Bool) {
        let inputMessage = TransferMessage(
            code: CommandCode.ClientMessage.startProcess.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOStartProcess(stage: stage, start: start))
        )
        sut.redirectMessage(inputMessage, from: connection)
    }
    
    func generateBidForPlayers(_ players: [Player], sellingPlayer: Player) -> [Bid] {
        var bids: [(player: Player, bid: Int)] = []
        for player in players {
            if player.id != sellingPlayer.id {
                let inputBidMessage = Int.random(in: 1...10)
                bids.append((player, inputBidMessage))
            }
        }
        return bids
    }
    
    func sendBidsForSut(_ sut: ServerRouter, bids: [Bid], connection: Connection) {
        for bid in bids {
            let inputBidMessage = TransferMessage(
                code: CommandCode.ClientMessage.bid.rawValue,
                device: .iOS,
                message: try! JSONEncoder().encode(
                    DTOBid(stage: 33, bid: bid.bid, player: bid.player)
                )
            )
            sut.redirectMessage(inputBidMessage, from: connection)
        }
    }
    
    func sendFinishInningMessageForSut(_ sut: ServerRouter, connection: Connection) {
        let finishInningMessage = TransferMessage(
            code: CommandCode.ClientMessage.startProcess.rawValue,
            device: .tvOS,
            message: try! JSONEncoder().encode(
                DTOStartProcess(stage: 35, start: true)
            )
        )
        sut.redirectMessage(finishInningMessage, from: connection)
    }
}

extension ServerRouterTests {
    typealias SutAndDoubles = (sut: ServerRouter, doubles: (ServerMock, SpyConnection))
    func makeSUT() -> SutAndDoubles {
        let server = ServerMock()
        let connection = SpyConnection()
        let sut = ServerRouter(server: server)
        
        return (sut, (server, connection))
    }
}

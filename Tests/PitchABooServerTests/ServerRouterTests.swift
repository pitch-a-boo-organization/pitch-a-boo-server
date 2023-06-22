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
        let inputMessage = TransferMessage(
            code: CommandCode.ClientMessage.startProcess.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOStartProcess(stage: 31, start: true))
        )
        sut.redirectMessage(inputMessage, from: connection)
        XCTAssertEqual(server.gameSession.gameHasStarted, true)
    }
    
    func test_redirectMessage_startProccess_firstRoundStage_shouldnt_start_game_if_start_false() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputMessage = TransferMessage(
            code: CommandCode.ClientMessage.startProcess.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOStartProcess(stage: 31, start: false))
        )
        sut.redirectMessage(inputMessage, from: connection)
        XCTAssertEqual(server.gameSession.gameHasStarted, false)
    }
    
    func test_redirectMessage_startProccess_firstRoundStage_should_send_chooseSellingPlayer_to_clients() throws {
        let (sut, (server, connection)) = makeSUT()
        let inputMessage = TransferMessage(
            code: CommandCode.ClientMessage.startProcess.rawValue,
            device: .iOS,
            message: try! JSONEncoder().encode(DTOStartProcess(stage: 31, start: true))
        )
        let inputPlayer = Player(
            id: 0,
            name: Player.availableNames.first!,
            bones: 0,
            sellingItem: Item.availableItems.first!,
            persona: Persona.availablePersonas.first!
        )
        server.gameSession.players.append(inputPlayer)
        sut.redirectMessage(inputMessage, from: connection)
        XCTAssertNotNil(server.sendedMessageToAllClients)
        XCTAssertEqual(server.sendMessageToAllClientsCalled, 1)
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

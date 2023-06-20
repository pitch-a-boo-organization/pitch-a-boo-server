import XCTest
import Network
@testable import PitchABooServer

final class PitchABooServerTests: XCTestCase {
    func testExample() throws {
        let server = try PitchABooWebSocketServer(port: 8080)
        server.startServer { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

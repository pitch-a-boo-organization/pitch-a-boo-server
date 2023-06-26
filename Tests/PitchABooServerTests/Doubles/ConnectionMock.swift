//
//  File.swift
//  
//
//  Created by Thiago Henrique on 22/06/23.
//

import Foundation
import Network
@testable import PitchABooServer

class SpyConnection: Connection {
    var stateUpdateHandler: ((NWConnection.State) -> Void)?
    
    func receiveMessage(completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void) {
        
    }
    
    func start(queue: DispatchQueue) {
        
    }
    
    private(set) var sendCalledCount = 0
    
    func send(
        content: Data?,
        contentContext: NWConnection.ContentContext,
        isComplete: Bool,
        completion: NWConnection.SendCompletion
    ) {
        sendCalledCount += 1
    }
}

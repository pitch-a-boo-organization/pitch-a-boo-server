//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

final class ConnectionHandler: Handler {
    weak var server: PitchABooWebSocketServer?
    var inputMessage: TransferMessage
    
    public init(server: PitchABooWebSocketServer? = nil, inputMessage: TransferMessage) {
        self.server = server
        self.inputMessage = inputMessage
    }

    func handle() {
        
    }
}

//
//  File.swift
//  
//
//  Created by Thiago Henrique on 22/06/23.
//

import Foundation
import Network

public protocol Connection {
    func send(
        content: Data?,
        contentContext: NWConnection.ContentContext,
        isComplete: Bool,
        completion: NWConnection.SendCompletion
    )
}

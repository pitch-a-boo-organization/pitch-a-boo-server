//
//  File.swift
//  
//
//  Created by Thiago Henrique on 22/06/23.
//

import Foundation
import Network

public protocol Connection: AnyObject, Identifiable {
    
    var stateUpdateHandler: ((_ state: NWConnection.State) -> Void)? { get set }
    
    func send(
        content: Data?,
        contentContext: NWConnection.ContentContext,
        isComplete: Bool,
        completion: NWConnection.SendCompletion
    )
    
    func receiveMessage(completion: @escaping (_ completeContent: Data?, _ contentContext: NWConnection.ContentContext?, _ isComplete: Bool, _ error: NWError?) -> Void)
    
    func start(queue: DispatchQueue)
}

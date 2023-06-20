//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

protocol Handler {
    var server: PitchABooWebSocketServer? { get set }
    var inputMessage: TransferMessage { get set }
    func handle() 
}

//
//  File.swift
//  
//
//  Created by Thiago Henrique on 15/06/23.
//

import Foundation

struct TransferMessage: Codable {
    let type: MessageType
    let message: String
}

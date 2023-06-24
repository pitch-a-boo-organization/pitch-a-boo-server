//
//  File.swift
//  
//
//  Created by Thiago Henrique on 15/06/23.
//

import Foundation

public struct TransferMessage: Codable {
    let code: Int
    let device: Device
    let message: Data
    
    public init(code: Int, device: Device, message: Data) {
        self.code = code
        self.device = device
        self.message = message
    }
    
    func encodeToTransfer() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

public enum Device: Int, Codable {
    case iOS = 1
    case tvOS = 2
    case coreOS = 3
}


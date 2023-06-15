//
//  File.swift
//  
//
//  Created by Thiago Henrique on 15/06/23.
//

import Foundation

enum WebSocketError: LocalizedError {
    case unableToStartInPort(UInt16)
    case unableToInitializeListener
    case serverInitializationFail(String?)
    case cantHandleClientMessage
    case unableToSendAMessageToUser
    case cantConnectWithClient
    case connectTimeWasTooLong
    
    var errorDescription: String? {
        switch self {
        case .unableToStartInPort(let port):
            return "Não foi possível iniciar o servidor na porta: \(port)"
        case .unableToInitializeListener:
            return "Não foi possível iniciar a comunicação com o servidor"
        case .serverInitializationFail(let error):
            return "A inicialização do servidor falhou \(error ?? "")"
        case .cantHandleClientMessage:
            return "Não foi possível receber a mensagem do client"
        case .unableToSendAMessageToUser:
            return "Não foi possível enviar a mensagem para o usuário"
        case .cantConnectWithClient:
            return "A conexão com o cliente falhou"
        case .connectTimeWasTooLong:
            return "O tempo de espera foi muito longo"
        }
    }
}

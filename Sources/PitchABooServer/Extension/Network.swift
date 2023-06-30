//
//  File.swift
//  
//
//  Created by Thiago Henrique on 22/06/23.
//

import Foundation
import Network

extension NWConnection: Connection {
    private struct AssociatedKeys {
        static var player: Player = Player.createAnUndefinedPlayer()
    }
    
    public var associatedPlayer: Player {
        get {
            guard let player = objc_getAssociatedObject(self, &AssociatedKeys.player) as? Player else { return Player.createAnUndefinedPlayer()  }
            return player
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.player, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

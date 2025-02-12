//
//  Player.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

import Foundation

enum Player {
    case x
    case o

    var opponent: Player {
        self == .o ? .x : .o
    }

    var symbol: String {
        switch self {
        case .x:
            return "X"
        case .o:
            return "O"
        }
    }
}

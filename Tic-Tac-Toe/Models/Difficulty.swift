//
//  Difficulty.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

import Foundation

enum Difficulty: CaseIterable {
    case normal
    case hard
}

extension Difficulty: CustomStringConvertible {
    var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .hard:
            return "Hard"
        }
    }
}

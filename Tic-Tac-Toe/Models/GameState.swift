//
//  GameState.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-11.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

import Foundation

typealias GameState = [[Player?]]

extension GameState {
    func possibleMoves(for player: Player) -> [(Move, GameState)] {
        var moves: [(Move, GameState)] = []
        for row in 0..<3 {
            for col in 0..<3 {
                if canPlay(move: .init(row: row, col: col)) {
                    var newState = self
                    newState[row][col] = player
                    moves.append((Move(row: row, col: col), newState))
                }
            }
        }
        return moves
    }

    func canPlay(move: Move) -> Bool {
        self[move.row][move.col] == nil
    }

    func isTerminal() -> Bool {
        return winner() != nil || !flatMap { $0 }.contains(nil)
    }

    func utility(for player: Player) -> Int {
        guard let winner = winner() else { return 0 }
        return winner == player ? 1 : -1
    }

    func winner() -> Player? {
        for i in 0..<3 {
            if self[i][0] != nil, self[i][0] == self[i][1], self[i][1] == self[i][2] {
                return self[i][0]
            }
            if self[0][i] != nil, self[0][i] == self[1][i], self[1][i] == self[2][i] {
                return self[0][i]
            }
        }

        if self[0][0] != nil, self[0][0] == self[1][1], self[1][1] == self[2][2] {
            return self[0][0]
        }
        if self[0][2] != nil, self[0][2] == self[1][1], self[1][1] == self[2][0] {
            return self[0][2]
        }
        return nil
    }
}

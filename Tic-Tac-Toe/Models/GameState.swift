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
    var isTerminal: Bool {
        return winner != nil || flatMap { $0 }.contains(nil) == false
    }

    var winner: Player? {
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

    mutating func play(_ move: Move, for player: Player) {
        self[move.row][move.col] = player
    }

    mutating func reset() {
        self = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    }

    func canPlay(_ move: Move) -> Bool {
        self[move.row][move.col] == nil
    }

    func possibleMoves(for player: Player) -> [(Move, GameState)] {
        var moves: [(Move, GameState)] = []
        for row in 0..<3 {
            for col in 0..<3 {
                let move = Move(row: row, col: col)
                if canPlay(move) {
                    var newState = self
                    newState.play(move, for: player)
                    moves.append((Move(row: row, col: col), newState))
                }
            }
        }
        return moves
    }

    func utility(for player: Player) -> Int {
        guard let winner = winner else {
            return 0
        }
        return winner == player ? 1 : -1
    }

    func utility(for player: Player, at depth: Int, maxDepth: Int) -> Int {
        guard let winner = winner else {
            return 0
        }
        return winner == player ? maxDepth - depth : -maxDepth + depth
    }

}

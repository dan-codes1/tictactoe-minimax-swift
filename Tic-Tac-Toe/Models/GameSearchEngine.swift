//
//  GameSearchEngine.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

struct GameSearchEngine {
    /// - Note: Randomizing may lead to less quality results.
    var randomize = false
    func searchMove(for player: Player, in state: GameState) -> Move? {
        maxValue(for: player, in: state, with: 0, alpha: Int.min, beta: Int.max).move
    }
}

private extension GameSearchEngine {
    func maxValue(for player: Player, in state: GameState, with depth: Int, alpha: Int, beta: Int) -> (utility: Int, move: Move?) {
        guard state.isTerminal == false else {
            return (state.utility(for: player), nil)
        }
        var alpha = alpha
        var value = Int.min
        /// All the possible moves with their associated values
        var moves: [(val: Int, move: Move)] = []
        var move: Move? = nil
        let possibleMoves = state.possibleMoves(for: player)
        for (m1, s1) in possibleMoves {
            let (v1, _) = minValue(for: player, in: s1, with: depth + 1, alpha: alpha, beta: beta)
            moves.append((v1, m1))
            if v1 > value {
                value = v1
                move = m1
                alpha = max(alpha, value)
            }
            if value >= beta {
                return (value, move)
            }
        }
        if randomize && depth == 0 { // only randomize the final moves in the search
            let bestRandomizedMoves = moves.filter({ $0.val == value }).shuffled()
            let bestRandomizedMove = bestRandomizedMoves.first ?? (0, nil)
            return (bestRandomizedMove.0, bestRandomizedMove.1)
        }
        return (value, move)
    }

    func minValue(for player: Player, in state: GameState, with depth: Int, alpha: Int, beta: Int) -> (utility: Int, move: Move?) {
        guard state.isTerminal == false else {
            return (state.utility(for: player), nil)
        }
        var beta = beta
        var value = Int.max
        var move: Move? = nil
        let possibleMoves = state.possibleMoves(for: player.opponent)
        for (m1, s1) in possibleMoves {
            let (v1, _) = maxValue(for: player, in: s1, with: depth + 1, alpha: alpha, beta: beta)
            if v1 < value {
                value = v1
                move = m1
                beta = min(beta, value)
            }
            if value <= alpha {
                return(value, move)
            }
        }
        return (value, move)
    }
}

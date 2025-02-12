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
        maxValue(for: player, in: state, with: 0).move
    }
}

private extension GameSearchEngine {
    func maxValue(for player: Player, in state: GameState, with depth: Int) -> (utility: Int, move: Move?) {
        guard state.isTerminal == false else {
            return (state.utility(for: player), nil)
        }
        var value = Int.min
        /// All the possible moves with their associated values
        var moves: [(val: Int, move: Move)] = []
        var bestMove: Move? = nil
        let possibleMoves = state.possibleMoves(for: player)
        for (m1, s1) in possibleMoves {
            let (v1, _) = minValue(for: player, in: s1, with: depth + 1)
            if v1 > value {
                value = v1
                bestMove = m1
            }
            moves.append((v1, m1))
        }
        if randomize && depth == 0 { // only randomize the final moves in the search
            let bestRandomizedMoves = moves.filter({ $0.val == value }).shuffled()
            let bestRandomizedMove = bestRandomizedMoves.first ?? (0, nil)
            return (bestRandomizedMove.0, bestRandomizedMove.1)
        }
        return (value, bestMove)
    }

    func minValue(for player: Player, in state: GameState, with depth: Int) -> (utility: Int, move: Move?) {
        guard state.isTerminal == false else {
            return (state.utility(for: player), nil)
        }
        var value = Int.max
        var bestMove: Move? = nil
        let possibleMoves = state.possibleMoves(for: player.opponent)
        for (m1, s1) in possibleMoves {
            let (v1, _) = maxValue(for: player, in: s1, with: depth + 1)
            if v1 < value {
                value = v1
                bestMove = m1
            }
        }
        return (value, bestMove)
    }
}

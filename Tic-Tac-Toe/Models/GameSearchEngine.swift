//
//  GameSearchEngine.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

struct GameSearchEngine {
    func searchMove(for player: Player, in state: GameState) -> Move? {
        maxValue(for: player, in: state, with: 0).move
    }
}

private extension GameSearchEngine {
    func maxValue(for player: Player, in state: GameState, with depth: Int) -> (utility: Int, move: Move?) {
        guard state.isTerminal() == false else {
            return (state.utility(for: player), nil)
        }
        var value = Int.min
        var bestMove: Move? = nil
        let possibleMoves = state.possibleMoves(for: player)
        for (m1, s1) in possibleMoves {
            let (v1, _) = minValue(for: player, in: s1, with: depth + 1)
            if v1 > value {
                value = v1
                bestMove = m1
            }
        }
        return (value, bestMove)
    }

    func minValue(for player: Player, in state: GameState, with depth: Int) -> (utility: Int, move: Move?) {
        guard state.isTerminal() == false else {
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

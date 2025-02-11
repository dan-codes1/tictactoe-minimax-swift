//
//  GameSearchEngine.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

struct GameSearchEngine {
    func searchMove(for player: Player, in state: GameState) -> Move? {
        maxValue(for: player, in: state).move
    }
}

private extension GameSearchEngine {
    func maxValue(for player: Player, in state: GameState) -> (utility: Int, move: Move?) {
        if state.isTerminal() {
            return (state.utility(for: player), nil)
        }
        var value = Int.min
        var bestMove: Move? = nil
        for (m1, s1) in state.possibleMoves(for: player) {
            let (v1, _) = minValue(for: player, in: s1)
            if v1 > value {
                value = v1
                bestMove = m1
            }
        }
        return (value, bestMove)
    }

    func minValue(for player: Player, in state: GameState) -> (utility: Int, move: Move?) {
        if state.isTerminal() {
            return (state.utility(for: player), nil)
        }
        var value = Int.max
        var bestMove: Move? = nil
        for (m1, s1) in state.possibleMoves(for: player.opponent) {
            let (v1, _) = maxValue(for: player, in: s1)
            if v1 < value {
                value = v1
                bestMove = m1
            }
        }
        return (value, bestMove)
    }
}

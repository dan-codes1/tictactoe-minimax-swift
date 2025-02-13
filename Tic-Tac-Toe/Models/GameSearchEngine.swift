struct GameSearchEngine {
    /// - Note: Randomizing may lead to less quality results.
    ///     Randomizations are also only done for player 'x'.
    var randomize = false

    func searchMove(for player: Player, in state: GameState) -> Move? {
        return maxValue(for: player, in: state, with: 0, alpha: Int.min, beta: Int.max).move
    }
}

private extension GameSearchEngine {
    func maxValue(for player: Player, in state: GameState, with depth: Int, alpha: Int, beta: Int) -> (utility: Int, move: Move?) {
        if state.isTerminal {
            return (state.utility(for: player), nil)
        }

        var alpha1 = alpha
        var value = Int.min
        var move: Move? = nil
        var moves: [(val: Int, move: Move)] = []
        let possibleMoves = state.possibleMoves(for: player)

        for (m1, s1) in possibleMoves {
            let (v1, _) = minValue(for: player, in: s1, with: depth + 1, alpha: alpha1, beta: beta)
            moves.append((v1, m1))

            if v1 > value {
                value = v1
                move = m1
                alpha1 = max(alpha1, value)
            }

            if value >= beta {
                return (value, move)
            }
        }

        if randomize && depth == 0 && player == .x {
            let bestMoves = moves.filter { $0.val == value }
            move = bestMoves.randomElement()?.move
        }

        return (value, move)
    }

    func minValue(for player: Player, in state: GameState, with depth: Int, alpha: Int, beta: Int) -> (utility: Int, move: Move?) {
        if state.isTerminal {
            return (state.utility(for: player), nil)
        }

        var beta1 = beta
        var value = Int.max
        var move: Move? = nil
        let possibleMoves = state.possibleMoves(for: player.opponent)

        for (m1, s1) in possibleMoves {
            let (v1, _) = maxValue(for: player, in: s1, with: depth + 1, alpha: alpha, beta: beta1)

            if v1 < value {
                value = v1
                move = m1
                beta1 = min(beta1, value)
            }

            if value <= alpha {
                return (value, move)
            }
        }

        return (value, move)
    }
}

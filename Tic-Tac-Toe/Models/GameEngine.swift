//
//  GameEngine.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

final class GameEngine {
    private let human: Player
    private let ai: Player

    init(human: Player, ai: Player) {
        self.human = human
        self.ai = ai
    }

    func isMovesLeft(in board: [[Player?]]) -> Bool {
        return board.joined().contains(nil)
    }

    func evaluate(_ board: [[Player?]]) -> Int {
        for i in 0..<3 {
            if let player = board[i][0], player == board[i][1], player == board[i][2] {
                return player == ai ? 10 : -10
            }
            if let player = board[0][i], player == board[1][i], player == board[2][i] {
                return player == ai ? 10 : -10
            }
        }
        if let player = board[1][1] {
            if (board[0][0] == player && board[2][2] == player) ||
               (board[0][2] == player && board[2][0] == player) {
                return player == ai ? 10 : -10
            }
        }
        return 0
    }
    
    func minimax(board: [[Player?]], isMax: Bool, alpha: inout Int, beta: inout Int) -> Int {
        var board = board
        let score = evaluate(board)
        if score == 10 || score == -10 { return score }
        if !isMovesLeft(in: board) { return 0 }
        
        if isMax {
            var best = -1000
            for i in 0..<3 {
                for j in 0..<3 where board[i][j] == nil {
                    board[i][j] = ai
                    best = max(best, minimax(board: board, isMax: false, alpha: &alpha, beta: &beta))
                    board[i][j] = nil
                    alpha = max(alpha, best)
                    if beta <= alpha { return best }
                }
            }
            return best
        } else {
            var best = 1000
            for i in 0..<3 {
                for j in 0..<3 where board[i][j] == nil {
                    board[i][j] = human
                    best = min(best, minimax(board: board, isMax: true, alpha: &alpha, beta: &beta))
                    board[i][j] = nil
                    beta = min(beta, best)
                    if beta <= alpha { return best }
                }
            }
            return best
        }
    }

    func findBestMove(in board: [[Player?]]) -> Move? {
        var board = board
        var bestVal = -1000
        var bestMove: Move? = nil
        var alpha = -1000
        var beta = 1000
        
        for i in 0..<3 {
            for j in 0..<3 where board[i][j] == nil {
                board[i][j] = ai
                let moveVal = minimax(board: board, isMax: false, alpha: &alpha, beta: &beta)
                board[i][j] = nil

                if moveVal > bestVal {
                    bestMove = Move(row: i, col: j)
                    bestVal = moveVal
                }
            }
        }
        return bestMove
    }
}

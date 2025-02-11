//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published var board: [[Player?]]
    @Published private(set) var ai: Player
    @Published private(set) var human: Player
    @Published private(set) var currentPlayerTurn: Player
    @Published private(set) var winner: Player?
    private var game: GameEngine

    init() {
        let board: [[Player?]] = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        let randInt = Int.random(in: 0...1)
        let human: Player = randInt == 0 ? .x : .o
        let ai: Player = randInt == 0 ? .o : .x
        self.board = board
        self.currentPlayerTurn = .x
        self.human = human
        self.ai = ai
        self.game = .init(human: human, ai: ai)
        if currentPlayerTurn == ai {
            playForAI()
        }
    }

    var gameOver: Bool {
        return board.flatMap { $0 }.contains(nil) == false || winner != nil
    }

    func playMove(_ move: Move) {
        guard board[move.row][move.col] == nil && currentPlayerTurn == human && !gameOver else {
            return
        }
        board[move.row][move.col] = human
        checkForWinner()
        currentPlayerTurn.toggle()
        playForAI()
    }

    func resetGame() {
        self.board = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        self.currentPlayerTurn = .x
        let randInt = Int.random(in: 0...1)
        self.human = randInt == 0 ? .x : .o
        self.ai = randInt == 0 ? .o : .x
        self.game = .init(human: human, ai: ai)
        winner = nil
        if currentPlayerTurn == ai {
            playForAI()
        }
    }
}

private extension GameViewModel {
    func configure() {
        board = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    }

    func playForAI() {
        guard currentPlayerTurn == ai && !gameOver else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else {
                return
            }
            if let aiMove = game.findBestMove(in: board) {
                board[aiMove.row][aiMove.col] = ai
                checkForWinner()
            }
            currentPlayerTurn.toggle()
        }
    }

    func checkForWinner() {
        // Row & Column Check
        for i in 0..<3 {
            if board[i][0] == board[i][1], board[i][1] == board[i][2] {
                winner = board[i][0]
                return
            }
            if board[0][i] == board[1][i], board[1][i] == board[2][i] {
                winner = board[0][i]
                return
            }
        }

        // Diagonal Check
        if board[0][0] == board[1][1], board[1][1] == board[2][2] {
            winner = board[0][0]
            return
        }
        if board[0][2] == board[1][1], board[1][1] == board[2][0] {
            winner = board[0][2]
            return
        }
    }
}

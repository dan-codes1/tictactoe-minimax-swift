//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published var state: GameState
    @Published private(set) var ai: Player
    @Published private(set) var human: Player
    @Published private(set) var currentPlayer: Player
    @Published private(set) var winner: Player?

    init() {
        let board: [[Player?]] = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        let randInt = Int.random(in: 0...1)
        let human: Player = randInt == 0 ? .x : .o
        let ai: Player = randInt == 0 ? .o : .x
        self.state = board
        self.currentPlayer = .x
        self.human = human
        self.ai = ai
        if currentPlayer == ai {
            playForAI()
        }
    }

    var gameOver: Bool {
        return state.flatMap { $0 }.contains(nil) == false || winner != nil
    }

    func playMove(_ move: Move) {
        guard state[move.row][move.col] == nil && currentPlayer == human && !gameOver else {
            return
        }
        state[move.row][move.col] = human
        checkForWinner()
        currentPlayer = currentPlayer.opponent
        playForAI()
    }

    func resetGame() {
        self.state = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        self.currentPlayer = .x
        let randInt = Int.random(in: 0...1)
        self.human = randInt == 0 ? .x : .o
        self.ai = randInt == 0 ? .o : .x
        winner = nil
        if currentPlayer == ai {
            playForAI()
        }
    }
}

private extension GameViewModel {
    func configure() {
        state = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    }

    func playForAI() {
        guard currentPlayer == ai && !gameOver else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else {
                return
            }
            let engine = GameSearchEngine()
            if let move = engine.searchMove(for: ai, in: state) {
                print(move)
                state[move.row][move.col] = ai
                checkForWinner()
            }
            currentPlayer = currentPlayer.opponent
        }
    }

    func checkForWinner() {
        // Row & Column Check
        for i in 0..<3 {
            if state[i][0] == state[i][1], state[i][1] == state[i][2] {
                winner = state[i][0]
                return
            }
            if state[0][i] == state[1][i], state[1][i] == state[2][i] {
                winner = state[0][i]
                return
            }
        }

        // Diagonal Check
        if state[0][0] == state[1][1], state[1][1] == state[2][2] {
            winner = state[0][0]
            return
        }
        if state[0][2] == state[1][1], state[1][1] == state[2][0] {
            winner = state[0][2]
            return
        }
    }
}

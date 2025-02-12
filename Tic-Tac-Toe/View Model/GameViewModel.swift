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
        guard state.canPlay(move: move) && currentPlayer == human && !gameOver else {
            return
        }
        state.play(move, for: human)
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
                state.play(move, for: ai)
                checkForWinner()
            }
            currentPlayer = currentPlayer.opponent
        }
    }

    func checkForWinner() {
        winner = state.winner()
    }
}

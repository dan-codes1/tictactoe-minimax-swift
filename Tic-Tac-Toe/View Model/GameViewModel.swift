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
        state.isTerminal()
    }

    var winner: Player? {
        state.winner()
    }

    func playMove(_ move: Move) {
        guard state.canPlay(move: move) && currentPlayer == human && !gameOver else {
            return
        }
        state.play(move, for: human)
        currentPlayer = currentPlayer.opponent
        playForAI()
    }

    func resetGame() {
        self.state = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        self.currentPlayer = .x
        let randInt = Int.random(in: 0...1)
        self.human = randInt == 0 ? .x : .o
        self.ai = randInt == 0 ? .o : .x
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
            let engine = GameSearchEngine(randomize: true)
            if let move = engine.searchMove(for: ai, in: state) {
                state.play(move, for: ai)
            }
            currentPlayer = currentPlayer.opponent
        }
    }

}

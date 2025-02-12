//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published private(set) var state: GameState
    @Published private(set) var ai: Player
    @Published private(set) var human: Player
    @Published private(set) var currentPlayer: Player
    private var isSearchingAIMove: Bool
    private let searchEngine: GameSearchEngine

    init() {
        let state: [[Player?]] = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        let randInt = Int.random(in: 0...1)
        let human: Player = randInt == 0 ? .x : .o
        let ai: Player = randInt == 0 ? .o : .x
        self.state = state
        self.human = human
        self.ai = ai
        self.currentPlayer = .x
        self.searchEngine = GameSearchEngine(randomize: true)
        self.isSearchingAIMove = false
        if currentPlayer == ai {
            playForAI()
        }
    }

    var gameOver: Bool {
        state.isTerminal
    }

    var winner: Player? {
        state.winner
    }

    func playMove(_ move: Move) {
        guard state.canPlay(move) && currentPlayer == human && !gameOver else {
            return
        }
        state.play(move, for: human)
        currentPlayer = currentPlayer.opponent
        playForAI()
    }

    func resetGame() {
        let randInt = Int.random(in: 0...1)
        state.reset()
        human = randInt == 0 ? .x : .o
        ai = randInt == 0 ? .o : .x
        currentPlayer = .x
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
        guard currentPlayer == ai && !gameOver && !isSearchingAIMove else {
            return
        }
        isSearchingAIMove = true
        Task {
            let move = searchEngine.searchMove(for: ai, in: state)
            await MainActor.run {
                if let move = move {
                    state.play(move, for: ai)
                }
                currentPlayer = currentPlayer.opponent
                isSearchingAIMove = false
            }
        }
    }
}

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
        self.searchEngine = GameSearchEngine()
        self.isSearchingAIMove = false
        if currentPlayer == ai {
            Task {
                await playForAI()
            }
        }
    }

    var gameOver: Bool {
        state.isTerminal
    }

    var winner: Player? {
        winnerInfo.player
    }

    var winningCells: [(Int, Int)] {
        winnerInfo.cells
    }

    func playMove(_ move: Move) {
        guard state.canPlay(move) && currentPlayer == human && !gameOver else {
            return
        }
        state.play(move, for: human)
        currentPlayer = currentPlayer.opponent
        Task {
            await playForAI()
        }
    }

    func resetGame() {
        let randInt = Int.random(in: 0...1)
        state.reset()
        human = randInt == 0 ? .x : .o
        ai = randInt == 0 ? .o : .x
        currentPlayer = .x
        if currentPlayer == ai {
            Task {
                await playForAI()
            }
        }
    }
}

private extension GameViewModel {
    var winnerInfo: (player: Player?, cells: [(Int, Int)]) {
        state.winner
    }

    func configure() {
        state = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    }

    func playForAI(delay: DispatchTime = .now() + 1.2) async {
        guard currentPlayer == ai && !gameOver && !isSearchingAIMove else {
            return
        }
        isSearchingAIMove = true
        let move: Move?
        if state.flatMap({ $0 }).contains(where: { $0 != nil }) == false {
            // randomly generate first move for AI
            move = generateRandomFirstMove()
        } else {
            move = searchEngine.searchMove(for: ai, in: state)
        }
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            guard let self else {
                return
            }
            if let move = move {
                state.play(move, for: ai)
            }
            currentPlayer = currentPlayer.opponent
            isSearchingAIMove = false
        }
    }

    func generateRandomFirstMove() -> Move {
        let row = Int.random(in: 0..<3)
        let col = Int.random(in: 0..<3)
        return Move(row: row, col: col)
    }
}

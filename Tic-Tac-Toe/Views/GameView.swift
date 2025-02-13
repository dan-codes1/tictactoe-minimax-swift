//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Daniel Eze on 2025-02-10.
//  Copyright © 2025 Daniel Eze. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack {
            Text("Tic-Tac-Toe")
                .font(.largeTitle)
                .padding()
            
            GridStack(rows: 3, columns: 3) { row, col in
                Button {
                    viewModel.playMove(Move(row: row, col: col))
                } label: {
                    Text(viewModel.state[row][col]?.symbol ?? "")
                        .font(.largeTitle)
                        .frame(width: 80, height: 80)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .opacity(isWinningCell((row, col)) ? 1 : 0.3)
                }
            }

            if viewModel.gameOver {
                Text(gameOverText)
                    .padding()
            } else {
                HStack {
                    Text("Player turn:")
                    Text(currPlayerText)
                        .fontWeight(.medium)
                }
                .padding()
            }

            HStack {
                Text("Difficulty:")
                Picker("Difficulty", selection: $viewModel.difficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.description)
                            .id(difficulty)
                            .tag(difficulty)
                    }
                }
            }
            .padding()

            Button("Reset Game") {
                viewModel.resetGame()
            }
            .padding()
        }
        .animation(.default, value: viewModel.gameOver)
        .animation(.default, value: viewModel.currentPlayer)
        .animation(.default, value: viewModel.difficulty)
    }

}

private extension GameView {
    var currPlayerText: String {
        viewModel.currentPlayer == viewModel.human ? "You" : "AI"
    }

    var gameOverText: String {
        guard let winner = viewModel.winner else {
            return "Draw!"
        }
        return winner == viewModel.ai ? "AI Won!" : "You Won!"
    }

    func isWinningCell(_ cell: (Int, Int)) -> Bool {
        guard viewModel.gameOver && viewModel.winner != nil else {
            return withAnimation {
                true
            }
        }
        return withAnimation {
            viewModel.winningCells.contains(where: { $0 == cell })
        }
    }
}

#Preview {
    GameView()
}

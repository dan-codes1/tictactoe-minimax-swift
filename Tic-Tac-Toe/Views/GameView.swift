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

            Button("Reset Game") {
                viewModel.resetGame()
            }
            .padding()
        }
        .animation(.default, value: viewModel.gameOver)
        .animation(.default, value: viewModel.currentPlayer)

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
}

#Preview {
    GameView()
}

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
                if viewModel.winner == viewModel.ai {
                    Text("AI Won!")
                        .padding()
                } else if viewModel.winner == viewModel.human {
                    Text("You Won!")
                        .padding()
                } else {
                    Text("Draw!")
                        .padding()
                }
            } else {
                HStack {
                    Text("Player turn: ")
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
        if viewModel.currentPlayer == viewModel.human {
            return "You"
        }
        return "AI"
    }
}

#Preview {
    GameView()
}

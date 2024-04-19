//
//  AlphabetPage.swift
//  aslApp
//
//  Created by Ellie Kim on 4/11/24.
//

import SwiftUI

struct AlphabetPage: View {
    
    @State private var selectedLetter: String? = nil
    
    private func letterSelection(letter: String) {
        selectedLetter = letter
        print("Selected letter is \(letter)")
    }
    
    var body: some View {
            VStack {
                Text("Alphabet")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
                    .padding(.top, 20)
                ScrollView {
                    VStack(spacing: 40) {
                        Spacer()
                        HStack(spacing: 40) {
                            LearningWidget(learning: "A", image: Image("a"), onSelect: letterSelection)
                             LearningWidget(learning: "B", image: Image("b"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "C", image: Image("c"), onSelect: letterSelection)
                            LearningWidget(learning: "D", image: Image("d"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "E", image: Image("e"), onSelect: letterSelection)
                            LearningWidget(learning: "F", image: Image("f"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "G", image: Image("g"), onSelect: letterSelection)
                            LearningWidget(learning: "H", image: Image("h"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "I", image: Image("i"), onSelect: letterSelection)
                            LearningWidget(learning: "J", image: Image("j"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "K", image: Image("k"), onSelect: letterSelection)
                            LearningWidget(learning: "L", image: Image("l"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "M", image: Image("m"), onSelect: letterSelection)
                            LearningWidget(learning: "N", image: Image("n"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "O", image: Image("o"), onSelect: letterSelection)
                            LearningWidget(learning: "P", image: Image("p"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "Q", image: Image("q"), onSelect: letterSelection)
                            LearningWidget(learning: "R", image: Image("r"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "S", image: Image("s"), onSelect: letterSelection)
                            LearningWidget(learning: "T", image: Image("t"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "U", image: Image("u"), onSelect: letterSelection)
                            LearningWidget(learning: "V", image: Image("v"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "W", image: Image("w"), onSelect: letterSelection)
                            LearningWidget(learning: "X", image: Image("x"), onSelect: letterSelection)
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "Y", image: Image("y"), onSelect: letterSelection)
                            LearningWidget(learning: "Z", image: Image("z"), onSelect: letterSelection)
                        }
                    }
                }
                .scrollIndicators(.never)
            }
        }
    }

#Preview {
    AlphabetPage()
}

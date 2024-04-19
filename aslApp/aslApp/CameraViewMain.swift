//
//  CameraViewMain.swift
//  aslApp
//
//  Created by Ellie Kim on 4/19/24.
//

import SwiftUI

struct CameraViewMain: View {
    @State private var prediction: String = ""

    var body: some View {
        VStack {
            CameraView(prediction: $prediction)
                .scaledToFill()
                .frame(height: 300)

            Text("Prediction: \(prediction)")
                .padding()
        }
    }
}

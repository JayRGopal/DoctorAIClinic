//
//  ChatView.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import SwiftUI
import SwiftData

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel() // ViewModel for logic

    var body: some View {
        VStack {
            Text("Enter Your Details")
                .font(.title)

            TextField("Your Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Your Symptoms", text: $viewModel.symptoms)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Submit") {
                viewModel.submitPatient() // Calls function from ViewModel
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}


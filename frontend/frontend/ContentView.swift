//
//  ContentView.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: SymptomsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Doctor AI Clinic")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Describe your symptoms...", text: $viewModel.symptoms)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(height: 100)
                
                Button(action: {
                    viewModel.sendSymptoms()
                }) {
                    Text(viewModel.isLoading ? "Sending..." : "Send Symptoms")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading || viewModel.symptoms.isEmpty)
                .padding()
                
                if !viewModel.response.isEmpty {
                    Text("Response from Doctor:")
                        .font(.headline)
                        .padding(.top)
                    
                    Text(viewModel.response)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: SymptomsViewModel())
    }
}

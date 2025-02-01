//
//  SymptomsViewModel.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import Foundation

class SymptomsViewModel: ObservableObject {
    @Published var symptoms: String = ""
    @Published var response: String = ""
    @Published var isLoading: Bool = false
    
    func sendSymptoms() {
        guard !symptoms.isEmpty else { return }
        
        isLoading = true
        APIService.shared.sendSymptoms(symptoms: symptoms) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let res):
                    self.response = res
                case .failure(let error):
                    self.response = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

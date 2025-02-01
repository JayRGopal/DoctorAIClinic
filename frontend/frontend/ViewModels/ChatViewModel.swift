//
//  ChatViewModel.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var symptoms: String = ""

    func submitPatient() {
        let newPatient = Patient(name: name, symptoms: symptoms)
        print("Patient submitted: \(newPatient.name), \(newPatient.symptoms)")
        // In a real app, you’d save this to a database or send it to an API.
    }
}

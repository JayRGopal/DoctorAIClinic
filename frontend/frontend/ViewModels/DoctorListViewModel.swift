//
//  DoctorListViewModel.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import Foundation
import SwiftData

class DoctorListViewModel: ObservableObject {
    @Published var doctors: [Doctor] = []

    init() {
        fetchDoctors()
    }

    func fetchDoctors() {
        // Placeholder for fetching doctors from a database or API
        doctors = [
            Doctor(name: "Dr. Smith", specialty: "Cardiology"),
            Doctor(name: "Dr. Johnson", specialty: "Dermatology"),
            Doctor(name: "Dr. Lee", specialty: "Neurology")
        ]
    }
}

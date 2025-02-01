//
//  Doctor.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import Foundation
import SwiftData

@Model
class Doctor {
    var name: String
    var specialty: String
    
    init(name: String, specialty: String) {
        self.name = name
        self.specialty = specialty
    }
}

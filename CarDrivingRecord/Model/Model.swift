//
//  Model.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import Foundation

struct Location: Hashable, Identifiable, Codable {
    var id = UUID()
    
    let latitude: Double
    let longitude: Double
    let address: String
}

enum DeviationType: Int, Codable {
  case acceleration = -300
  case normal = 0
  case deceleration = 300
}

struct DrivingRecord: Hashable, Identifiable, Codable {
    var id = UUID()
    
    let location: Location

    let speed: Double //(KPH)
    
    let deviation: Double

    let time: Date
    
    let deviationType: DeviationType
}

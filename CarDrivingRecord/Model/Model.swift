//
//  Model.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import Foundation

struct LocationRecord: Hashable, Identifiable, Codable {
    var id = UUID()
    
    let latitude: Double
    let longitude: Double
}

struct DrivingRecord: Hashable, Identifiable, Codable {
    var id = UUID()
    
    let speed: Double //(KPH)
    
    let time: Date
    
    let location: LocationRecord
}

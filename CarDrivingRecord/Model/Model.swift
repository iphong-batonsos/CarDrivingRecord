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

struct DrivingRecord: Hashable, Identifiable, Codable {
    var id = UUID()
    
    let location: Location

    let speed: Double //(KPH)
    
    let deviation: Double

    let time: Date
    
    let rapidAcc: Bool
    
    let rapidDec: Bool
}

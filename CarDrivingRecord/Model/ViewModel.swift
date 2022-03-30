//
//  ViewModel.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import Foundation
import Combine

class ViewModel: ObservableObject {    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

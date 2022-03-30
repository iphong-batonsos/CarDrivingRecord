//
//  ViewModel.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published var locationService: LocationService
    var cancellable : AnyCancellable?
    
    init(locationService: LocationService) {
        self.locationService = locationService
        
        self.cancellable = self.locationService.$latDisplay.sink(
            receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
            }
        )
        
        self.cancellable = self.locationService.$lonDisplay.sink(
            receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
            }
        )
        
        self.cancellable = self.locationService.$headingDisplay.sink(
            receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
            }
        )
        
        self.cancellable = self.locationService.$avgSpeedLabel.sink(
            receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
            }
        )
        
        self.cancellable = self.locationService.$speedDisplay.sink(
            receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
            }
        )
        
        self.cancellable = self.locationService.$distanceTraveled.sink(
            receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
            }
        )
        
//        self.cancellable = self.locationService.$maxSpeedLabel.sink(
//            receiveValue: { [weak self] _ in
//                self?.objectWillChange.send()
//            }
//        )
//
//        self.cancellable = self.locationService.$minSpeedLabel.sink(
//            receiveValue: { [weak self] _ in
//                self?.objectWillChange.send()
//            }
//        )
    }
}

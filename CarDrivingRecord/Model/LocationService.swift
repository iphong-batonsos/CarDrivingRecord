//
//  LocationService.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import Foundation
import CoreLocation
import MapKit

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    //MARK: Global Var's
    var locationManager: CLLocationManager = CLLocationManager()
    var lastLocation: CLLocation!
    
    @Published var traveledDistance:Double = 0
    @Published var arrayKPH: [Double]! = []

    @Published var speedDisplay: String = ""
    @Published var headingDisplay: String = ""
    @Published var latDisplay: String = ""
    @Published var lonDisplay: String = ""
    @Published var distanceTraveled: String = ""
    @Published var minSpeedLabel: String = ""
    @Published var maxSpeedLabel: String = ""
    @Published var avgSpeedLabel: String = ""

    override init() {
        super.init()
        
        DispatchQueue.main.async {
            self.minSpeedLabel = "0"
            self.maxSpeedLabel = "0"
        }
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // 백그라운드 있을 때 위치 업데이트 허용
        self.locationManager.allowsBackgroundLocationUpdates = true
        // 위치 업데이트 자동 종료 거부
        self.locationManager.pausesLocationUpdatesAutomatically = false
        // 백그라운드 위치 인디케이터 노출
        self.locationManager.showsBackgroundLocationIndicator = true
        // 위치 정확도 최고 설정
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
    }

    // 1 mile = 5280 feet
    // Meter to miles = m * 0.00062137
    // 1 meter = 3.28084 feet
    // 1 foot = 0.3048 meters
    // km = m / 1000
    // m = km * 1000
    // ft = m / 3.28084
    // 1 mile = 1609 meters
    
    //MARK: Location
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if (location!.horizontalAccuracy > 0) {
            updateLocationInfo(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, speed: location!.speed, direction: location!.course)
        }
        if lastLocation != nil {
            traveledDistance += lastLocation.distance(from: locations.last!)
            if traveledDistance < 1609 {
                let tdMeter = traveledDistance
                DispatchQueue.main.async {
                    self.distanceTraveled = (String(format: "%.0f Meters", tdMeter))
                }
            } else if traveledDistance > 1609 {
                let tdKm = traveledDistance / 1000
                DispatchQueue.main.async {
                    self.distanceTraveled = (String(format: "%.1f Km", tdKm))
                }
            }
        }
        
        lastLocation = locations.last
    }

    func updateLocationInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees, speed: CLLocationSpeed, direction: CLLocationDirection) {
        let speedToKPH = (speed * 3.6)
        let val = ((direction / 22.5) + 0.5);
        let arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
        let dir = arr[Int(val.truncatingRemainder(dividingBy: 16))]
        
//        lonDisplay = coordinateString(latitude, longitude: longitude)
        
        DispatchQueue.main.async {
            self.lonDisplay = (String(format: "%.3f", longitude))
            self.latDisplay = (String(format: "%.3f", latitude))
        }
        
        print("\(self.lonDisplay), \(self.latDisplay)")
        
        // Checking if speed is less than zero
        if (speedToKPH > 0) {
            speedDisplay = (String(format: "%.0f km/h", speedToKPH))
            arrayKPH.append(speedToKPH)
            let lowSpeed = arrayKPH.min()
            let highSpeed = arrayKPH.max()
            DispatchQueue.main.async {
                self.minSpeedLabel = (String(format: "%.0f km/h", lowSpeed!))
                self.maxSpeedLabel = (String(format: "%.0f km/h", highSpeed!))
            }
            avgSpeed()
            //print("Low: \(lowSpeed!) - High: \(highSpeed!)")
        } else {
            DispatchQueue.main.async {
                self.speedDisplay = "0 km/h"
            }
        }

        DispatchQueue.main.async {
        // Shows the N - E - S W
            self.headingDisplay = "\(dir)"
            print("\(self.headingDisplay)")
        }
    }

    func avgSpeed() {
        let speed:[Double] = arrayKPH
        let speedAvg = speed.reduce(0, +) / Double(speed.count)
        DispatchQueue.main.async {
            self.avgSpeedLabel = (String(format: "%.0f", speedAvg))
        }
    }

    func resetTrip() {
        self.locationManager.delegate = nil

        arrayKPH = []
        traveledDistance = 0
        
        DispatchQueue.main.async {
            self.minSpeedLabel = "0"
            self.maxSpeedLabel = "0"
            self.headingDisplay = "None"
            self.speedDisplay = "0"
            self.distanceTraveled = "0"
            self.avgSpeedLabel = "0"
        }
    }

    func startTrip() {
        print(#function)
        self.locationManager.delegate = self

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func endTrip() {
        print(#function)
        locationManager.stopUpdatingLocation()
    }
}

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
    
    @Published var traveledDistance: Double = 0
    @Published var drivingRecordArray: [DrivingRecord] = []
    @Published var speedArray: [Double]! = []
    @Published var deviationArray: [Double]! = []
    @Published var deviationTypeArray: [Double] = []

    @Published var rapidAccCount: Int = 0
    @Published var rapidDecCount: Int = 0
    
    @Published var speedDisplay: String = ""
    @Published var headingDisplay: String = ""
    @Published var latDisplay: String = ""
    @Published var lonDisplay: String = ""
    @Published var distanceTraveled: String = ""
    @Published var minSpeedLabel: String = ""
    @Published var maxSpeedLabel: String = ""
    @Published var avgSpeedLabel: String = ""
    
    @Published var rapidSpeed: Int = 10

    override init() {
        super.init()
        
        initString()
        
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
    
    fileprivate func initString() {
        DispatchQueue.main.async {
            self.lonDisplay = "-"
            self.latDisplay = "-"
            self.minSpeedLabel = "0"
            self.maxSpeedLabel = "0"
            self.headingDisplay = "None"
            self.speedDisplay = "0"
            self.distanceTraveled = "0"
            self.avgSpeedLabel = "0"
        }
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
        
        if lastLocation != nil && location!.speed > 0 {
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
        var currentSpeed = (speed * 3.6)
        let val = ((direction / 22.5) + 0.5);
        let arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
        let dir = arr[Int(val.truncatingRemainder(dividingBy: 16))]
        var deviation: Double = 0
        var deviationType: DeviationType = .normal

        var addressStr = ""
        let converter: LocationConverter = LocationConverter()
        let (x, y): (Int, Int)
        = converter.convertGrid(lon: longitude, lat: latitude)
        
        let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr") // Korea
        
        //        lonDisplay = coordinateString(latitude, longitude: longitude)
        
        DispatchQueue.main.async {
            self.lonDisplay = (String(format: "%.3f", longitude))
            self.latDisplay = (String(format: "%.3f", latitude))
        }
        
        print("\(self.lonDisplay), \(self.latDisplay)")
        
        DispatchQueue.main.async {
            // Shows the N - E - S W
            self.headingDisplay = "\(dir)"
            print("\(self.headingDisplay)")
        }
        
        // Checking if speed is less than zero
        if (currentSpeed > 0) {
            speedDisplay = (String(format: "%.0f km/h", currentSpeed))
            
            geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { [weak self] (place, error) in
                guard let self = self else { return }
                
                if let address: [CLPlacemark] = place {
                    guard let addressData = address.last else { return }
                    print("(longitude, latitude) = (\(x), \(y))")
                    addressStr = "\(addressData.administrativeArea!) \(addressData.locality!) \(addressData.name!)"
                    print("위치: \(addressStr)")

                    if let lastSpeed = self.speedArray.last {
                        deviation = currentSpeed - lastSpeed

                        if deviation >= Double(self.rapidSpeed) {
                            DispatchQueue.main.async {
                                self.rapidAccCount += 1
                            }
                            
                            deviationType = .acceleration

                        } else if deviation <= Double(-self.rapidSpeed) {
                            DispatchQueue.main.async {
                                self.rapidDecCount += 1
                            }
                            
                            deviationType = .deceleration

                        }
                        print("deviationType", Double(deviationType.rawValue))
                        self.deviationTypeArray.append(Double(deviationType.rawValue))
                        print("self.deviationTypeArray", self.deviationTypeArray)
                    }
                    
                    let location = Location(latitude: latitude, longitude: longitude, address: addressStr)
                    let drivingRecord = DrivingRecord(location: location, speed: currentSpeed, deviation: deviation, time: Date(), deviationType: deviationType)
                    
                    self.drivingRecordArray.append(drivingRecord)
                    self.speedArray.append(currentSpeed)
                    self.deviationArray.append(deviation)
                    
                    let lowSpeed = self.speedArray.min()
                    let highSpeed = self.speedArray.max()
                    
                    DispatchQueue.main.async {
                        self.minSpeedLabel = (String(format: "%.0f km/h", lowSpeed!))
                        self.maxSpeedLabel = (String(format: "%.0f km/h", highSpeed!))
                    }
                    
                    self.avgSpeed()
                    print("Low: \(lowSpeed!) - High: \(highSpeed!)")
                    
                }
            }            
        } else {
            DispatchQueue.main.async {
                self.speedDisplay = "0 km/h"
            }
        }
    }
    
    func avgSpeed() {
        let speed:[Double] = speedArray
        let speedAvg = speed.reduce(0, +) / Double(speed.count)
        DispatchQueue.main.async {
            self.avgSpeedLabel = (String(format: "%.0f km/h", speedAvg))
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
    
    func resetTrip() {
        self.locationManager.delegate = nil
        
        drivingRecordArray = []
        speedArray = []
        deviationArray = []
        
        traveledDistance = 0
        rapidSpeed = 10
        
        initString()
    }
}

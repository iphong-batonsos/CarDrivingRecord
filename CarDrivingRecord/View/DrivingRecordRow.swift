//
//  DrivingRecordRow.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/31.
//

import SwiftUI

struct DrivingRecordRow: View {
    let drivingData: DrivingRecord
    var formatter: DateFormatter = DateFormatter()
    
    init(drivingData: DrivingRecord) {
        self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.formatter.locale = Locale(identifier: "ko_kr")
        self.formatter.timeZone = TimeZone(abbreviation: "KST")
        self.drivingData = drivingData
        
        print("Loading row \(drivingData)")
    }
    
    var body: some View {
        VStack() {
            HStack() {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 4) {
                        Text("시간")
                            .foregroundColor(.gray)
                        Text(formatter.string(from: drivingData.time))
                    }
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("위치")
                            .foregroundColor(.gray)
                        Text(drivingData.location.address)
                    }
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    
                    HStack {
                        VStack {
                            HStack(alignment: .top, spacing: 4) {
                                Text("속도")
                                    .foregroundColor(.gray)
                                Text("\(String(format: "%.0f", drivingData.speed)) km/h")
                            }
                            .font(.system(size: 16, weight: .semibold, design: .default))
                        }
                        
                        VStack {
                            HStack(alignment: .top, spacing: 4) {
                                Text("속도 편차")
                                    .foregroundColor(.gray)
                                Text("\(String(format: "%.0f", drivingData.deviation)) km/h")
                            }
                            .font(.system(size: 16, weight: .semibold, design: .default))
                        }
                    }
                }
                
                Spacer().frame(width: 10)
                
                if drivingData.deviationType == .acceleration {
                    Text("급가속")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(.orange)
                        .padding()
                }
                
                if drivingData.deviationType == .deceleration {
                    Text("급감속")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)

            Divider()
        }
        .frame(width: UIScreen.main.bounds.width - 20)
    }
    
}

struct DrivingRecordRow_Previews: PreviewProvider {
    static var previews: some View {
        DrivingRecordRow(drivingData: DrivingRecord(location: Location(latitude: 37.404, longitude: 127.106, address: "경기도 성남시 삼평동 400"), speed: 44, deviation: 0, time: Date(), deviationType: .acceleration))
    }
}

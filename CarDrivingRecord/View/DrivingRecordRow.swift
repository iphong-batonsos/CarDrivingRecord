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
    @State private var rapidSpeed = ""
    
    init(drivingData: DrivingRecord) {
        self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.formatter.locale = Locale(identifier: "ko_kr")
        self.formatter.timeZone = TimeZone(abbreviation: "KST")
        self.drivingData = drivingData
        print("Loading row \(drivingData)")
        
        if drivingData.rapidAcc {
            rapidSpeed = "급가속"
        } else if drivingData.rapidDec {
            rapidSpeed = "급감속"
        }
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
                
                Spacer().frame(width: 20)
                
                if self.rapidSpeed.count > 0 {
                    Text(self.rapidSpeed)
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 5)
                        )
                }
                
                Spacer()
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)

            Divider()
        }
        .frame(width: UIScreen.main.bounds.width - 20, height: 40)
    }
    
}

struct DrivingRecordRow_Previews: PreviewProvider {
    static var previews: some View {
        DrivingRecordRow(drivingData: DrivingRecord(location: Location(latitude: 37.404, longitude: 127.106, address: "경기도 성남시 삼평동 398"), speed: 44, deviation: 0, time: Date(), rapidAcc: true, rapidDec: false))
            .previewDevice("iPhone SE (3rd generation)")
    }
}

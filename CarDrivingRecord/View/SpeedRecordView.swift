//
//  SpeedRecordView.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import SwiftUI
import SwiftUICharts

struct SpeedRecordView: View {
    @EnvironmentObject var locationService: LocationService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            
            HStack(alignment: .top) {
                VStack(spacing: -4) {
                    HStack {
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .imageScale(.medium)
                                .font(.title3)
                        }
                        
                        Spacer()
                            .frame(width: 20, height: 20)
                    }
                    
                    Text("운행 기록 그래프")
                        .font(.system(size: 24, weight: .bold, design: .default))
                }
            }
            
            if locationService.speedArray.count > 0 {
                ScrollView {
                    
                    LineView(data: locationService.speedArray, title: "") // legend is optional, use optional .padding()
                        .frame(width: UIScreen.main.bounds.width - 20, height: 400, alignment: .topLeading)
                    Divider()
                        .padding()
                    
                    LazyVStack {
                        ForEach(locationService.drivingRecordArray, id: \.self, content: DrivingRecordRow.init)
                    }
                    
                    Spacer()
                }
            }
            else{
                VStack {
                    Spacer()
                    Text("데이터 없음")
                        .padding()
                    Spacer()
                }
            }
        }
        
    }
}

struct DrivingRecordRow: View {
    let drivingData: DrivingRecord
    var formatter: DateFormatter = DateFormatter()
    
    init(drivingData: DrivingRecord) {
        self.formatter.dateFormat = "YY/MM/dd HH:mm:ss"
        self.drivingData = drivingData
        print("Loading row \(drivingData)")
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                
                Text(formatter.string(from: drivingData.time))
                Text("\(String(format: "%.0f", drivingData.speed)) km/h")
                
                if drivingData.rapidAcc {
                    Text("급가속")
                }
                
                if drivingData.rapidDec {
                    Text("급감속")
                }
                Spacer()
            }
            Divider()
        }
        .frame(width: UIScreen.main.bounds.width - 20, height: 40)
    }
    
}


struct SpeedRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedRecordView()
            .environmentObject(LocationService())
    }
}

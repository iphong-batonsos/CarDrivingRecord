//
//  DrivingRecordView.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import SwiftUI
import SwiftUICharts

struct DrivingRecordView: View {
    @EnvironmentObject var locationService: LocationService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            
            HStack(alignment: .top) {
                VStack() {
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
            
            if locationService.drivingRecordArray.count > 0 {
                ScrollView {
                    MultiLineChartView(data: [(locationService.speedArray, GradientColors.green), (locationService.deviationArray, GradientColors.bluPurpl), (locationService.deviationTypeArray, GradientColors.orngPink)], title: "속도 편차")
                        .padding()

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

struct DrivingRecordView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingRecordView()
            .environmentObject(LocationService())
    }
}

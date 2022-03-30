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
                LineView(data: locationService.speedArray, title: "") // legend is optional, use optional .padding()
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

struct SpeedRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedRecordView()
            .environmentObject(LocationService())
    }
}

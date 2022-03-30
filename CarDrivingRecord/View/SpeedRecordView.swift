//
//  SpeedRecordView.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import SwiftUI
import SwiftUICharts

struct SpeedRecordView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            HStack {
                ZStack {
                    Text("운행 기록 그래프")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .padding()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            dismiss()

                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                                .font(.title3)
                        }
                        
                        Spacer()
                            .frame(width: 20, height: 20)
                    }
                }
            }
            
            
            if viewModel.locationService.speedArray.count > 0 {
                LineView(data: viewModel.locationService.speedArray, title: "") // legend is optional, use optional .padding()
            }
            else{
                VStack {
                    Spacer()
                    Text("데이터 없음")
                        .foregroundColor(.red)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .padding()
                    Spacer()
                }
            }

        }
     
    }
}

struct SpeedRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedRecordView(viewModel: ViewModel(locationService: LocationService()))
    }
}

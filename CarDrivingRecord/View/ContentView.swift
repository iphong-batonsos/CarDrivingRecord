//
//  ContentView.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel(locationService: LocationService())
    @State private var showingSheet = false

    var body: some View {
        VStack {
            Text("자동차 운전 기록")
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding()
            
            List() {
                VStack(alignment: .leading, spacing: 10) {
                    Text("위도 \(viewModel.locationService.latDisplay)")
                    Text("경도 \(viewModel.locationService.lonDisplay)")
                    Text("방향 \(viewModel.locationService.headingDisplay)")
                    
                    Text("현재 속도 \(viewModel.locationService.speedDisplay)")
                    Text("평균 속도 \(viewModel.locationService.avgSpeedLabel)")
//                    Text("최대 속도 \(viewModel.locationService.maxSpeedLabel)")
//                    Text("최소 속도 \(viewModel.locationService.minSpeedLabel)")
                    
                    Text("운행 거리 \(viewModel.locationService.distanceTraveled)")
                }
                .font(.system(size: 18, weight: .semibold, design: .default))
                .padding([.top, .bottom])
                
                Button("운행 기록 그래프") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    SpeedRecordView()
                }
                
                Button {
                    viewModel.locationService.startTrip()
                } label: {
                    Text("운전 시작")
                }
                
                Button {
                    viewModel.locationService.endTrip()
                } label: {
                    Text("운전 종료")
                }
                
                Button {
                    viewModel.locationService.resetTrip()
                } label: {
                    Text("재설정")
                        .foregroundColor(.red)
                }

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

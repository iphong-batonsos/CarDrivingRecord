//
//  ContentView.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @EnvironmentObject var locationService: LocationService
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            Text("자동차 운전 기록")
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding()
            
            List() {
                HStack(spacing: -6) {
                    Text("급과속/급감속 기준 속도")
                        .fontWeight(.semibold)
                    
                    TextField("과속 기준 속도를 입력하세요.", value: $locationService.rapidSpeed, formatter: viewModel.formatter)
                        .frame(width: 60, alignment: .leading)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Text("km/h")
                        .fontWeight(.semibold)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("위도 \(locationService.latDisplay)")
                    Text("경도 \(locationService.lonDisplay)")
                    Text("방향 \(locationService.headingDisplay)")
                    
                    Text("현재 속도 \(locationService.speedDisplay)")
                    Text("평균 속도 \(locationService.avgSpeedLabel)")
                    Text("최대 속도 \(locationService.maxSpeedLabel)")
                    Text("최소 속도 \(locationService.minSpeedLabel)")
                    
                    Text("운행 거리 \(locationService.distanceTraveled)")
                    
                    Text("급가속 횟수 \(locationService.rapidAccCount)")

                    Text("급감속 횟수 \(locationService.rapidDecCount)")

                }
                .font(.system(size: 18, weight: .semibold, design: .default))
                .padding([.top, .bottom])
                
                Button("운행 기록 그래프") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    DrivingRecordView()
                        .environmentObject(locationService)
                }
                
                Button {
                    locationService.startTrip()
                } label: {
                    Text("운전 시작")
                }
                
                Button {
                    locationService.endTrip()
                } label: {
                    Text("운전 종료")
                }
                
                Button {
                    locationService.resetTrip()
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

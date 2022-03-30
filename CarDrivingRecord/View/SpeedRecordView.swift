//
//  SpeedRecordView.swift
//  CarDrivingRecord
//
//  Created by Inpyo Hong on 2022/03/30.
//

import SwiftUI

struct SpeedRecordView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}

struct SpeedRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedRecordView()
    }
}

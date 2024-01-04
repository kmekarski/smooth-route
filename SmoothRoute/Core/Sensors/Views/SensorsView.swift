//
//  SensorsView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 08/11/2023.
//

import SwiftUI

struct SensorsView: View {
    @EnvironmentObject var sensorsVM: SensorsViewModel
    @State var showSensorsHistory = false
    @State var showParameters = false
    @Binding var expanded: Bool
    
    var body: some View {
        ModalView(isShowing: $expanded, height: 600) {
            ScrollView {
                VStack(spacing: 20) {
                    resultDisplay
                    Divider()
                    sensorsHistory
                    Divider()
                    parameters
                    Divider()
                }
            }
        }
    }
}

struct SensorsView_Previews: PreviewProvider {
    static var previews: some View {
        SensorsView(expanded: .constant(true))
            .environmentObject(dev.locationSearchVM)
            .environmentObject(dev.mapStateManager)
            .environmentObject(dev.sensorsVM)
    }
}

extension SensorsView {
    private var parameters: some View {
        VStack(spacing: 20) {
            Toggle(isOn: $showParameters) {
                Text("Parameters")
                    .font(.title2)
            }
            if(showParameters) {
                ParameterSlider(title: "Instability impact", value: $sensorsVM.instabilityImpact, range: 0...10)
                ParameterSlider(title: "Instability threshold", value: $sensorsVM.instabilityThreshold, range: 0...1)
                ParameterSlider(title: "Speed sensitivity", value: $sensorsVM.speedSensitivity, range: 0...1)
            }
        }
    }
    
    private var sensorsHistory: some View {
        VStack(spacing: 10) {
            Toggle(isOn: $showSensorsHistory) {
                Text("Sensors History")
                    .font(.title2)
            }
            if(showSensorsHistory) {
                HStack {
                    Text("Vertical acceleration")
                        .frame(width: 150)
                    Text("Speed")
                        .frame(width: 150)
                }
                
                VStack{
                    ForEach(sensorsVM.verticalAccelerationHistory.indices, id: \.self) { index in
                        HStack {
                            Text("\(sensorsVM.verticalAccelerationHistory[index], specifier: "%.2f") g")
                                .frame(width: 150)
                            Text("\(sensorsVM.speedHistory[index], specifier: "%.0f") km/h")
                                .frame(width: 150)
                            
                            
                        }
                    }
                    
                }
                Text("Threshold exceeded: \(sensorsVM.thresholdExceededCount)/\(sensorsVM.verticalAccelerationHistory.count)")
            }
        }
    }
    
    private var resultDisplay: some View {
        VStack(spacing: 16) {
            Text("Road quality result:")
                .font(.title2)
            Text("\(sensorsVM.result, specifier: "%.1f")/10")
                .font(.largeTitle)
                .foregroundColor(Color.fromRating(sensorsVM.result))
        }
    }
}

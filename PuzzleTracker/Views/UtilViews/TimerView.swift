//
//  TimerView.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/10/23.
//

import SwiftUI

/// Util view to render a timer with an animated ring
struct TimerView: View {
    var timeLimit: Int
    @Binding var millisecondsPassed: Int
    
    private let timerUtil = TimerUtil()
    
    var body: some View {
        let progress: Double = Double(millisecondsPassed / 100) / Double(timeLimit)
        ZStack {
            Group {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.primary.opacity(0.09), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color("ButtonText"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color("ButtonText"), style: StrokeStyle(lineWidth: 5))
                    .blur(radius: 10)
                    .padding(-5)
                
            }.rotationEffect(.init(degrees: -90))
            VStack(spacing: 0) {
                HStack(spacing: 2) {
                    StopwatchUnit(timeUnit: millisecondsPassed / 6000, unitType: "minute", size: "large")
                    Text(":").font(.system(size: 48)).offset(y: -3)
                    StopwatchUnit(timeUnit: (millisecondsPassed % 6000) / 100, unitType: "second", size: "large")
                    Text(".").font(.system(size: 48))
                    StopwatchUnit(timeUnit: millisecondsPassed % 100, unitType: "millisecond", size: "large")
                }
                Text("Time Limit: \(timerUtil.secondsTominutes(seconds:timeLimit)):\(timerUtil.secondsToseconds(seconds:timeLimit))")
            }
        }
    }
}

#Preview {
    TimerView(timeLimit: 60, millisecondsPassed: .constant(0))
}

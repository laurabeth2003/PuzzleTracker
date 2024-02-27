//
//  TimePicker.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/1/23.
//

import SwiftUI

/// Util to render a TimePicker with minutes and seconds 
struct TimePicker: View {
    @Binding var seconds: Int
    @Binding var minutes: Int
    @State var height: CGFloat = 100
    
    var body: some View {
        HStack {
            Picker("", selection: $minutes){
                ForEach(0..<60, id: \.self) { i in
                    Text("\(i)").tag(i)
                }
            }
            .frame(height: height, alignment: .center)
            .pickerStyle(WheelPickerStyle())
            .compositingGroup()
            .clipped()
            Text("min")
            Picker("", selection: $seconds){
                ForEach(0..<60, id: \.self) { i in
                    Text("\(i)").tag(i)
                }
            }
            .frame(height: height, alignment: .center)
            .pickerStyle(WheelPickerStyle())
            .compositingGroup()
            .clipped()
            Text("sec")
        }
    }
}

/// Util to render a TimePicker with minutes, seconds, and milliseconds - symbols are used instead of abbreviations 
struct TimePickerMilli: View {
    @Binding var seconds: Int
    @Binding var minutes: Int
    @Binding var milliseconds: Int
    @State var height: CGFloat = 100
    
    var body: some View {
        HStack(spacing: 0) {
            Picker("", selection: $minutes){
                ForEach(0..<60, id: \.self) { i in
                    Text("\(i)").tag(i)
                }
            }
            .frame(width: 60, height: height, alignment: .center)
            .pickerStyle(WheelPickerStyle())
            .compositingGroup()
            .clipped()
            .padding(.trailing, -5)
            Text(":").frame(width: 5).bold()
            Picker("", selection: $seconds){
                ForEach(0..<60, id: \.self) { i in
                    Text("\(i)").tag(i)
                }
            }
            .frame(width: 60, height: height, alignment: .center)
            .pickerStyle(WheelPickerStyle())
            .compositingGroup()
            .clipped()
            .padding(.horizontal, -5)
            Text(".").frame(width: 5).bold()
            Picker("", selection: $milliseconds){
                ForEach(0..<100, id: \.self) { i in
                    Text("\(i)").tag(i)
                }
            }
            .frame(width: 60, height: height, alignment: .center)
            .pickerStyle(WheelPickerStyle())
            .compositingGroup()
            .clipped()
            .padding(.leading, -5)
        }
    }
}

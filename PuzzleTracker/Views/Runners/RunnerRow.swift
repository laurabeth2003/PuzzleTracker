//
//  RunnerRow.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/28/23.
//

import SwiftUI

struct RunnerRow: View {
    @State var runner: Runner
    
    var body: some View {
        let ageComponents = Calendar.current.dateComponents([.year], from: runner.birthDate, to: Date())
        let age = ageComponents.year!
        HStack {
            VStack {
                HStack {
                    Text(runner.name).fontWeight(.bold).font(.system(size: 19))
                    Spacer()
                }
                HStack {
                    Text(String(age)).padding(.bottom, 1)
                    Text("•")
                    Text(runner.gender.capitalized)
                    Spacer()
                }.font(.system(size: 15))
            }
        }
    }
}

#Preview {
    RunnerRow(runner: Runner.runner1)
}

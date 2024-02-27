//
//  DivisionList.swift
//  NinjaFit
//
//  Created by Laura Erickson on 12/3/23.
//

import SwiftUI
import RealmSwift

/// Use views to see a list of all Divisions associated with a course or delete Divisions
struct DivisionList: View {
    @Binding var divisions: [Division]
    @Binding var hasGenderDivisions: Bool
    
    @State var showAddDivision = false
    @State var divisionLabel = ""
    @State var enablePro = false
    @State var maxAge = 1
    @State var minAge = 1
    @State var hasHalfwayMark = YesNo.No
    @State var halfwayDescription = ""
    @State var maxDate = Date()
    @State var minDate = Date()
    @State var cutoffDate = Date()
    
    
    var body: some View {
        VStack(spacing: 0) {
            DatePicker(
                "Age Cutoff Date",
                selection: $cutoffDate,
                in: dateRange,
                displayedComponents: [.date]
            )
            .disabled(divisions.count > 0)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            Divider()
            Button(action: {
                showAddDivision.toggle()
            }, label: {
                HStack {
                    Text("Add Division")
                    Spacer()
                    Image(systemName: showAddDivision ? "chevron.up" : "chevron.down" )
                }
                .foregroundColor(Color("PlaceholderText"))
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
            })
            if showAddDivision {
                VStack(spacing: 5) {
                    EmbeddedCreateField(fieldName: "Division Label", fieldText: $divisionLabel)
                    HStack(spacing: 2) {
                        Text("Minimum Age:")
                        Spacer()
                        Picker("Minimum Age", selection: $minAge){
                            ForEach(1..<61, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                    }
                    HStack(spacing: 2) {
                        Text("Maximum Age:")
                        Spacer()
                        Picker("Maximum Age", selection: $maxAge){
                            ForEach(1..<61, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                    }
                    Toggle("Can Be Pro?", isOn: $enablePro)
                    Button(action: {
                        minDate = calculateDate(age: minAge)
                        maxDate = calculateDate(age: maxAge)
                        if (hasGenderDivisions) {
                            let maleDivision = Division()
                            maleDivision.label = divisionLabel + " (Male)"
                            maleDivision.minDate = minDate
                            maleDivision.maxDate = maxDate
                            maleDivision.includePro = enablePro
                            maleDivision.isMale = true
                            maleDivision.isFemale = false
                            
                            let femaleDivision = Division()
                            femaleDivision.label = divisionLabel + " (Female)"
                            femaleDivision.minDate = minDate
                            femaleDivision.maxDate = maxDate
                            femaleDivision.includePro = enablePro
                            femaleDivision.isMale = false
                            femaleDivision.isFemale = true
                            
                            divisions.append(maleDivision)
                            divisions.append(femaleDivision)
                            
                            let maleProDivision = divisions.first(where: { $0.label == "Pro (Male)"})
                            
                            let femaleProDivision =
                                divisions.first(where: {
                                $0.label == "Pro (Female)"})
                            
                            if let malePro = maleProDivision {
                                if (enablePro && malePro.minDate! < minDate) {
                                    malePro.minDate = minDate
                                }
                                if (enablePro && malePro.maxDate! > maxDate) {
                                    malePro.maxDate = maxDate
                                }
                            }
                            
                            if let femalePro = femaleProDivision {
                                if (enablePro && femalePro.minDate! < minDate) {
                                    femalePro.minDate = minDate
                                }
                                if (enablePro && femalePro.maxDate! > maxDate) {
                                    femalePro.maxDate = maxDate
                                }
                            }
                            
                            // if male pro is nil, then female doesn't exist either
                            if (enablePro && maleProDivision == nil) {
                                let femaleProDivision = Division()
                                let maleProDivision = Division()
                                femaleProDivision.minDate = minDate
                                maleProDivision.minDate = minDate
                                femaleProDivision.label = "Pro (Female)"
                                maleProDivision.label = "Pro (Male)"
                                femaleProDivision.maxDate = maxDate
                                maleProDivision.maxDate = maxDate
                                divisions.append(femaleProDivision)
                                divisions.append(maleProDivision)
                                
                            }
                        }
                        else {
                            let newDivision = Division()
                            newDivision.label = divisionLabel
                            newDivision.minDate = minDate
                            newDivision.maxDate = maxDate
                            newDivision.includePro = enablePro
                            newDivision.isMale = true
                            newDivision.isFemale = true
                            
                            let proDivision = divisions.first(where: { $0.label == "Pro"})
                            
                            if let pro = proDivision {
                                if (enablePro && pro.minDate! < minDate) {
                                    pro.minDate = minDate
                                }
                                if (enablePro && pro.maxDate! > maxDate) {
                                    pro.maxDate = maxDate
                                }
                            }
                            if (enablePro && proDivision == nil) {
                                let proDivision = Division()
                                proDivision.minDate = minDate
                                proDivision.label = "Pro"
                                proDivision.maxDate = maxDate
                                divisions.append(proDivision)
                            }
                        }
                        showAddDivision = false
                    }, label: {
                        Text("Add Division")
                    })
                    .frame(height: 32)
                    .foregroundStyle(Color("ButtonText"))
                    .padding(.top, 3)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.primary.opacity(0.05))
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .padding(.bottom, 7)
            }
            Divider()
            List {
                ForEach($divisions, id: \.self) {
                    division in DivisionRow(division: division)
                }
                .onDelete(perform: { indexSet in divisions.remove(atOffsets: indexSet)
                })
                .onMove(perform: move)
            }
            .navigationBarItems(trailing: EditButton().foregroundStyle(Color("ButtonText")))
            .listStyle(.plain)
        }
        .tint(.primary)
        .navigationTitle("Divisions")
        
    }
    
    func move(from source: IndexSet, to destination: Int) {
        divisions.move(fromOffsets: source, toOffset: destination)
    }
    
    func calculateDate(age: Int) -> Date {
        let calendar = Calendar.current
        let cutoffYear = calendar.component(.year, from: cutoffDate)
        let cutoffMonth = calendar.component(.month, from: cutoffDate)
        let cutoffDay = calendar.component(.day, from: cutoffDate)
        let dateRange = DateComponents(year: cutoffYear - age, month: cutoffMonth, day: cutoffDay)
        return calendar.date(from: dateRange)!
    }
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let startComponents = DateComponents(year: currentYear - 1, month: 1, day: 1)
        let endComponents = DateComponents(year: currentYear + 1, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
}

/// Enables the preview view for the DivisionView component
struct DivisionView_Previews: PreviewProvider {
    static var previews: some View {
        DivisionList(divisions: .constant([]), hasGenderDivisions: .constant(true))
    }
}



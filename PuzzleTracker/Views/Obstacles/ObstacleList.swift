import SwiftUI
import RealmSwift

/// Use views to see a list of all Obstacles associated with a course or delete Courses
struct ObstacleList: View {
    @Binding var obstacles: [Obstacle]
    
    @State var showAddObstacle = false
    @State var obstacleName = ""
    @State var hasHalfwayMark = YesNo.No
    @State var halfwayDescription = ""
    
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            Button(action: {
                showAddObstacle.toggle()
            }, label: {
                HStack {
                    Text("Add Obstacle")
                    Spacer()
                    Image(systemName: showAddObstacle ? "chevron.up" : "chevron.down" )
                }
                .foregroundColor(Color("PlaceholderText"))
                .padding(.horizontal, 23)
                .padding(.vertical, 12)
            })
            if showAddObstacle {
                VStack(spacing: 5) {
                    EmbeddedCreateField(fieldName: "Obstacle Name", fieldText: $obstacleName)
                    HStack {
                        Text("Halfway Point?")
                        Spacer()
                    }.font(Font.system(size: 14))
                    HStack {
                        Picker("", selection: $hasHalfwayMark) {
                            Text("Yes").tag(YesNo.Yes)
                            Text("No").tag(YesNo.No)
                        }.pickerStyle(SegmentedPickerStyle())
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    if (hasHalfwayMark == YesNo.Yes) {
                        EmbeddedCreateField(fieldName: "Halfway Point Description", fieldText: $halfwayDescription)
                    }
                    Button(action: {
                        let newObstacle = Obstacle()
                        newObstacle.name = obstacleName
                        newObstacle.hasHalfway = hasHalfwayMark == YesNo.Yes ? true : false
                        if (hasHalfwayMark == YesNo.Yes) {
                            newObstacle.halfwayDescription = halfwayDescription
                        }
                        obstacles.append(newObstacle)
                        showAddObstacle = false
                    }, label: {
                        Text("Add Obstacle")
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
                ForEach($obstacles, id: \.self) {
                    obstacle in ObstacleRow(obstacle: obstacle)
                }
                .onDelete(perform: { indexSet in obstacles.remove(atOffsets: indexSet)
                })
                .onMove(perform: move)
            }
            .navigationBarItems(trailing: EditButton().foregroundStyle(Color("ButtonText")))
            .listStyle(.plain)
        }
        .tint(.primary)
        .navigationTitle("Obstacles")
        
    }
    
    func move(from source: IndexSet, to destination: Int) {
        obstacles.move(fromOffsets: source, toOffset: destination)
    }
}

/// Enables the preview view for the ObstacleView component
struct ObstacleView_Previews: PreviewProvider {
    static var previews: some View {
        ObstacleList(obstacles: .constant([]))
    }
}



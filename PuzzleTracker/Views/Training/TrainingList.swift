import SwiftUI
import RealmSwift

/// View a list of user Training objects in the realm. User can swipe to delete Trainings.
struct TrainingList: View {
    /// Determines if the view is in Preview Mode
    @Environment(\.isInTrainingPreview) var isInTrainingPreview
    /// Collection of all Training objects in the realm sorted by createDate
    @ObservedResults(Training.self, sortDescriptor: SortDescriptor(keyPath: "createDate", ascending: true)) var trainings
    var trainingArray = Training.trainingPreview
    
    var body: some View {
        ZStack {
            Image("LoginBackground")
                .resizable()
                .ignoresSafeArea()
            Color("LoginOverlay")
                .ignoresSafeArea()
            VStack {
                List {
                    /// render List with preview data if isInTrainingPreview is true
                    if isInTrainingPreview {
                        ForEach(trainingArray) { training in
                            TrainingRow(training: training)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 7, leading: 17, bottom: 0, trailing: 17))
                        }
                    /// render List with Realm data if isInTrainigPreview is false
                    } else {
                        ForEach(trainings) { training in
                            TrainingRow(training: training)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 7, leading: 17, bottom: 0, trailing: 17))
                        }
                        .onDelete(perform: $trainings.remove)
                    }
                }
                .padding(.top, 10)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                
            }
        }
        
    }
}

/// setting isTrainingPreview to true if XCode is in Preview
public extension EnvironmentValues {
    var isInTrainingPreview: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        return false
        #endif
    }
}

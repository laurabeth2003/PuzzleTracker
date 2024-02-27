import SwiftUI
import RealmSwift

/// Use views to see a list of all Trainings, add or delete Trainings, or logout.
struct TrainingView: View {
    var leadingBarButton: AnyView?
    /// Collection of all Training objects in the realm
    @ObservedResults(Training.self) var training

    @State var userId: String
    
    @State private var courseSummary = ""
    @State private var isInCreateTrainingView = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    /// render CreateTrainingView if add button is pressed
                    if isInCreateTrainingView {
                        CreateTrainingView(isInCreateTrainingView: $isInCreateTrainingView, userId: userId)
                    }
                    /// render TrainingList initially 
                    else {
                        TrainingList()
                    }
                }
                .toolbarBackground(Color("LoginOverlay"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarItems(leading: self.leadingBarButton,
                                    trailing: HStack {
                    Button {
                        isInCreateTrainingView = true
                    } label: {
                        Image(systemName: "plus")
                    }.foregroundColor(.primary)
                })
            }
            .navigationBarTitle("Training", displayMode: .inline)
        }
        .tint(.primary)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

/// Enables the preview view for the TrainingView component
struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView(userId: "test")
    }
}


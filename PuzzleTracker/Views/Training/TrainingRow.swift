import SwiftUI
import RealmSwift

/// Renders a list item for the TrainingList
struct TrainingRow: View {
    @ObservedRealmObject var training: Training
    
    var body: some View {
        NavigationLink(destination: TrainingDetail(training: training)) {
            VStack {
                HStack {
                    Spacer()
                    Text(training.title).padding(.bottom, 1)
                    Spacer()
                }
                HStack {
                    Spacer()
                    IconView(icon: "line.3.horizontal.decrease.circle", text: training.type.capitalized)
                    Spacer()
                }.padding(.horizontal, 30)
            }
        }
        .foregroundColor(Color.primary)
        .padding(13)
        .background(
            LinearGradient(colors: [Color("CourseRowGradientLeft"), Color("CourseRowGradientRight")], startPoint: .leading, endPoint: .init(x: 1, y: 0)))
        .cornerRadius(20)
    }
}

/// Enables the preview view for the TrainingRow component
struct TrainingRow_Previews: PreviewProvider {
    static var previews: some View {
        TrainingRow(training: Training.training1)
    }
}



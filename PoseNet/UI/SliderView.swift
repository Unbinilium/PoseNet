import SwiftUI

struct SliderView: View {
    let description: String
    @Binding var value: Double
    var format: String = "%.2f"
    let range: ClosedRange<Double>
    @Binding var observableState: ObservableState
    
    var body: some View {
        VStack {
            HStack {
                Text(description)
                Spacer()
                Text(value.toString(format: format))
                    .bold()
            }
            .padding(.bottom, -5)
            
            Slider(value: $value, in: range, onEditingChanged: { _ in
                observableState = .changed
            })
            .padding(.bottom, 10)
        }
    }
}


// MARK: - Preview

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .fill(.yellow)
                .ignoresSafeArea()
            SliderView(
                description: "Slider",
                value: Binding.constant(1.0),
                range: 0...10, observableState:
                Binding.constant(ObservableState.staled)
            ).padding([.leading, .trailing], 15)
        }
    }
}

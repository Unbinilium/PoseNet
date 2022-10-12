import SwiftUI

struct ConfigurationPanelView: View {
    @Binding var poseBuilderConfiguration: PoseBuilderConfiguration
    @Binding var position: PanelPosition
    @Binding var observableState: ObservableState
    @GestureState private var panelState = PanelState.inactive

    private let maximumNumberOfPosesText = "Maximum number of poses"
    private let jointConfidenceThresholdText = "Joint confidence threshold"
    private let poseConfidenceThresholdText = "Pose confidence threshold"
    private let localJointSearchRadiusText = "Local joint search radius"
    private let matchingJointMinimumDistanceText = "Matching joint minimum distance"
    private let adjacentJointOffsetRefinementStepsText = "Adjacent joint refinement steps"
    
    var body: some View {
        GeometryReader { _ in
            Group() {
                // MARK: - Blur Panel View
                
                BlurView(style: .systemChromeMaterialDark)
                    .frame(height: UIScreen.main.bounds.height * 2)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.3), radius: 5)
                
                VStack {
                    // MARK: - Drag Indicator
                    
                    Capsule()
                        .foregroundColor(.white)
                        .frame(width: 80, height: 5)
                        .padding(.top, 10)
                        .padding(.bottom, 15)
                        .shadow(color: .black.opacity(0.2), radius: 3)
                    
                    // MARK: - Configurations
                    
                    Picker("Detection Algorithm", selection: $poseBuilderConfiguration.algorithm) {
                        Text("Single")
                            .tag(Algorithm.single)
                        Text("Multiple")
                            .tag(Algorithm.multiple)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    .onChange(of: poseBuilderConfiguration.algorithm) { _ in
                        observableState = ObservableState.changed
                    }
                    
                    VStack {
                        // Maximum number of poses
                        if poseBuilderConfiguration.algorithm == .multiple {
                            SliderView(
                                description: maximumNumberOfPosesText,
                                value: $poseBuilderConfiguration.maxPoseCount.asDouble,
                                format: "%.f",
                                range: 2...20,
                                observableState: $observableState)
                        }
                        
                        // Joint Confidence
                        SliderView(
                            description: jointConfidenceThresholdText,
                            value: $poseBuilderConfiguration.jointConfidenceThreshold,
                            range: 0...1,
                            observableState: $observableState)
                        
                        // Pose Confidence
                        SliderView(
                            description: poseConfidenceThresholdText,
                            value: $poseBuilderConfiguration.poseConfidenceThreshold,
                            range: 0...1,
                            observableState: $observableState)
                        
                        // Joint Search Radius
                        SliderView(
                            description: localJointSearchRadiusText,
                            value: $poseBuilderConfiguration.localSearchRadius.asDouble,
                            format: "%.f",
                            range: 0...50,
                            observableState: $observableState)
                        
                        // Joint Minimum Distance
                        SliderView(
                            description: matchingJointMinimumDistanceText,
                            value: $poseBuilderConfiguration.matchingJointDistance,
                            range: 0...100,
                            observableState: $observableState)
                        
                        // Joint Refinement Steps
                        SliderView(
                            description: adjacentJointOffsetRefinementStepsText,
                            value: $poseBuilderConfiguration.adjacentJointOffsetRefinementSteps.asDouble,
                            format: "%.f",
                            range: 0...50,
                            observableState: $observableState)
                        
                    }
                    .padding([.leading, .trailing], 5)
                    .animation(.spring(), value: poseBuilderConfiguration.algorithm)
                }
                .padding([.leading, .trailing], 10)
            }
        }
        .offset(y: position.rawValue + panelState.translation.height)
        .animation(.spring(), value: position.rawValue + panelState.translation.height)
        .gesture(
            DragGesture()
                .updating($panelState) { drag, state, transaction in
                    state = .dragging(translation: drag.translation)
                }
                .onEnded(onDragEnded)
        )
        .ignoresSafeArea(.all)
        .preferredColorScheme(.dark)
    }
    
    
    // MARK: - On Drag Ended
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let topEdgeLocation = position.rawValue + drag.translation.height
        let positionAbove: PanelPosition
        let positionBelow: PanelPosition
        let closestPosition: PanelPosition
        
        if topEdgeLocation <= PanelPosition.middle.rawValue {
            positionAbove = .top
            positionBelow = .middle
        } else {
            positionAbove = .middle
            positionBelow = .bottom
        }
        
        if (topEdgeLocation - positionAbove.rawValue) < (positionBelow.rawValue - topEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        
        if verticalDirection > 0 {
            position = positionBelow
        } else if verticalDirection < 0 {
            position = positionAbove
        } else {
            position = closestPosition
        }
    }
}


// MARK: - Preview

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .fill(.yellow)
                .ignoresSafeArea(.all)
            ConfigurationPanelView(
                poseBuilderConfiguration: Binding.constant(PoseBuilderConfiguration()),
                position: Binding.constant(.middle),
                observableState: Binding.constant(ObservableState.staled))
        }
    }
}

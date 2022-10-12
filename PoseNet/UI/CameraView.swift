import SwiftUI

struct CameraView: View {
    @StateObject private var cameraHandler = CameraHandler()
    @State private var poseBuilderConfiguration = PoseBuilderConfiguration()
    @State private var configurationPanelPosition = PanelPosition.bottom
    @State private var configurationPanelObservableState = ObservableState.staled
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - Frame
            
            Rectangle()
                .fill(.black)
                .overlay {
                    if let frame = cameraHandler.cachedFrame {
                        Image(frame, scale: 1, orientation: .up, label: Text("com.unbinilium.PoseNet.CachedFrame"))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .ignoresSafeArea(.all)
            
            VStack {
                // MARK: - Status Bar Dim
                
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .black.opacity(0.2), .clear]),
                                         startPoint: .top,
                                         endPoint: .bottom)
                    )
                    .frame(height: 70)
                    .ignoresSafeArea(.all)
                
                Spacer()
                // MARK: - Controls
                
                HStack(alignment: .center) {
                    if configurationPanelPosition == PanelPosition.bottom {
                        Button(action: {
                            cameraHandler.flipCamera()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                        }
                        .scaleEffect(1.5)
                        .background {
                            Circle()
                                .fill(.white.opacity(0.5))
                                .scaleEffect(3)
                                .shadow(color: .black.opacity(0.3), radius: 3)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            configurationPanelPosition = PanelPosition.middle
                        }) {
                            Image(systemName: "camera.fill.badge.ellipsis")
                        }
                        .scaleEffect(1.5)
                        .background {
                            Circle()
                                .fill(.white.opacity(0.5))
                                .scaleEffect(3)
                                .shadow(color: .black.opacity(0.3), radius: 3)
                        }
                    }
                }
                .foregroundColor(.white)
                .padding([.leading, .trailing, .bottom], 30)
                .animation(.spring(), value: configurationPanelPosition)
            }
            
            // MARK: - Configuration View
            ConfigurationPanelView(
                poseBuilderConfiguration: $poseBuilderConfiguration,
                position: $configurationPanelPosition,
                observableState: $configurationPanelObservableState
            ).onChange(of: configurationPanelObservableState) { state in
                if state == .changed {
                        cameraHandler.updatePoseBuilderConfiguration(poseBuilderConfiguration: poseBuilderConfiguration)
                        configurationPanelObservableState = ObservableState.staled
                    }
                }
        }
        .preferredColorScheme(.dark)
    }
}


// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

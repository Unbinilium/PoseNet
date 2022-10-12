import SwiftUI

extension Binding where Value == Int {
    var asFloat: Binding<Float> {
        return Binding<Float>(get: { Float(self.wrappedValue) }, set: { self.wrappedValue = Int($0)})
    }
    
    var asDouble: Binding<Double> {
        return Binding<Double>(get: { Double(self.wrappedValue) }, set: { self.wrappedValue = Int($0)})
    }
}

import Foundation

extension Int {
    func toString(format: String = "%d") -> String {
        return String(format: format, self)
    }
}

extension Float {
    func toString(format: String = "%f") -> String {
        return String(format: format, self)
    }
}

extension Double {
    func toString(format: String = "%f") -> String {
        return String(format: format, self)
    }
}

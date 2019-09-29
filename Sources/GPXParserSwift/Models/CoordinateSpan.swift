import Foundation

public struct CoordinateSpan: Codable {
    
    public var latitudeDelta: Double
    public var longitudeDelta: Double
    
    public init() {
        self.init(latitudeDelta: 0.0, longitudeDelta: 0.0)
    }
    
    public init(latitudeDelta: Double, longitudeDelta: Double) {
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
}

extension CoordinateSpan {
    
    public var description: String {
        return "Span: \(latitudeDelta), \(longitudeDelta)"
    }
}

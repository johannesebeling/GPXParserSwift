import Foundation

public struct Waypoint: Coordinate {
    
    // MARK: - Properties
    
    public var name: String?
    public var desc: String?
    
    public var latitude: Double
    public var longitude: Double
    
    // MARK: - Initializer
    
    public init() {
        latitude = 0.0
        longitude = 0.0
    }
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Waypoint {
    
    public var description: String {
        return """
        Name: \(name ?? "")
        Description: \(desc ?? "")
        Coordinate: \(latitude), \(longitude)
        """
    }
}

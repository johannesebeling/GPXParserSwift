public struct Waypoint: Coordinate {
    
    // MARK: - Properties
    
    public var name: String?
    public var desc: String?
    
    public var latitude: Double
    public var longitude: Double
    
    // MARK: - Initializer
    
    public init() {
        name = ""
        desc = ""
        latitude = 0.0
        longitude = 0.0
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

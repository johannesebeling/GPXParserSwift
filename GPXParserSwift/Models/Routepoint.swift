public struct Routepoint: Coordinate {
    
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
}

extension Routepoint {
    
    public var description: String {
        return """
        Name: \(name ?? "")
        Description: \(desc ?? "")
        Coordinate: \(latitude), \(longitude)
        """
    }
}

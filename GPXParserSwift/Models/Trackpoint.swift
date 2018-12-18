public struct Trackpoint: Coordinate {
    
    public var latitude: Double
    public var longitude: Double
    
    public init() {
        self.init(latitude: 0.0, longitude: 0.0)
    }
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct CoordinateRegion: Codable {
    
    public var southWest: Point
    public var northEast: Point
    
    public var center: Point {
        let latitude = northEast.latitude - (northEast.latitude - southWest.latitude) * 0.5
        let longitude = northEast.longitude + (southWest.longitude - northEast.longitude) * 0.5
        return Point(latitude: latitude, longitude: longitude)
    }
    
    public var span: CoordinateSpan {
        let latitudeDelta = abs(northEast.latitude - southWest.latitude)
        let longitudeDelta = abs(southWest.longitude - northEast.longitude)
        return CoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
    
    public init() {
        self.init(southWest: Point(), northEast: Point())
    }
    
    public init(southWest: Coordinate, northEast: Coordinate) {
        self.southWest = Point(latitude: southWest.latitude, longitude: southWest.longitude)
        self.northEast = Point(latitude: northEast.latitude, longitude: northEast.longitude)
    }
}

extension CoordinateRegion {
    
    public var description: String {
        return """
        \(center.description)
        \(span.description)
        """
    }
}

import CoreLocation

protocol Fix {
    
    var latitude: Double { get set }
    var longitude: Double { get set }
}

extension Fix {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var description: String {
        return "Fix \(latitude) \(longitude)"
    }
}

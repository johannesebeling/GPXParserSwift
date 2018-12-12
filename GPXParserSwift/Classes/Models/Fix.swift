import CoreLocation

public class Fix {
    
    var latitude = 0.0
    var longitude = 0.0
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var description: String {
        return "Fix \(latitude) \(longitude)"
    }
}

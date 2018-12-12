import MapKit

public class Track {
    
    public var region = MKCoordinateRegion()
    public var fixes = [Fix]()
    public var path = MKPolyline()
    public var shadowPath = MKPolyline()
}

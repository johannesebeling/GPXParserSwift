import MapKit

public class Track {
    
    public var region = MKCoordinateRegion()
    public var trackpoints = [Trackpoint]()
    public var path = MKPolyline()
}

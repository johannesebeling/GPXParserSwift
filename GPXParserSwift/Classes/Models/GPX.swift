import MapKit

public class GPX {
    
    public var tracks = [Track]()
    public var routes = [Track]()
    public var waypoints = [Waypoint]()
    public var filename = ""
    public var region = MKCoordinateRegion()
    public var distance = 0.0
}

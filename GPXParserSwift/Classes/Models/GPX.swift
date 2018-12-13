import MapKit

public class GPX: Response {
    
    public var tracks: [Track]
    public var routes: [Route]
    public var waypoints: [Waypoint]
    public var filename: String
    public var region: MKCoordinateRegion
    public var distance: Double
    
    required public init() {
        tracks = [Track]()
        routes = [Route]()
        waypoints = [Waypoint]()
        filename = ""
        region = MKCoordinateRegion()
        distance = 0.0
    }
}

public class GPX: Response {
    
    public var metadata: Metadata?
    public var tracks: [Track]
    public var routes: [Route]
    public var waypoints: [Waypoint]
    public var region: CoordinateRegion
    
    required public init() {
        tracks = [Track]()
        routes = [Route]()
        waypoints = [Waypoint]()
        region = CoordinateRegion()
    }
}

extension GPX {
    
    public var description: String {
        var base = "GPX: \n"
        base.append("\(metadata?.description ?? "")\n")
        base.append("Tracks:\n")
        tracks.forEach { (track) in
            base.append(track.description)
            base.append("\n")
        }
        base.append("Routes:\n")
        routes.forEach { (route) in
            base.append(route.description)
            base.append("\n")
        }
        base.append("Waypoints:\n")
        waypoints.forEach { (waypoint) in
            base.append(waypoint.description)
            base.append("\n")
        }
        return base
    }
}

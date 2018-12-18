public final class GPXParser: ConcreteParser<GPX> {
    
    // MARK: - Properties
    
    var metadata: Metadata?
    
    var track: Track?
    var route: Route?

    var waypoint: Waypoint?
    var routepoint: Routepoint?
    var trackpoint: Trackpoint?
    var previousTrackpoint: Trackpoint?
    
    // MARK: - XML Parser
    
    // MARK: - didStartElement
    
    @objc func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "gpx" {
            metadata = Metadata()
            metadata?.creator = attributeDict["creator"]
        }
        
        if elementName == "metadata" && metadata == nil {
            metadata = Metadata()
        }
        
        if elementName == "name" && metadata != nil {
            currentString = ""
        }
        
        if elementName == "copyright" && metadata != nil {
            metadata?.author = attributeDict["author"]
        }
        
        if elementName == "link" && metadata != nil {
            metadata?.link = attributeDict["href"]
        }
        
        if elementName == "time" && metadata != nil {
            currentString = ""
        }
        
        /// Track
        if elementName == "trk" {
            if track == nil {
                track = Track()
            }
        }
        
        /// Track name
        if elementName == "name" && track != nil {
            currentString = ""
        }
        
        /// Track point
        if elementName == "trkpt" && track != nil {
            if trackpoint == nil {
                trackpoint = Trackpoint()
                trackpoint?.latitude = Double(attributeDict["lat"] ?? "0.0") ?? 0.0
                trackpoint?.longitude = Double(attributeDict["lon"] ?? "0.0") ?? 0.0
            }
        }
        /// Route
        if elementName == "rte" {
            if route == nil {
                route = Route()
            }
            return
        }
        
        /// Route point
        if elementName == "rtept" && route != nil {
            if routepoint == nil {
                routepoint = Routepoint()
                routepoint?.latitude = Double(attributeDict["lat"] ?? "0.0") ?? 0.0
                routepoint?.longitude = Double(attributeDict["lon"] ?? "0.0") ?? 0.0
            }
        }
        
        /// Route name
        if elementName == "name" && route != nil {
            currentString = ""
        }
        
        /// Routepoint name
        if elementName == "name" && routepoint != nil {
            currentString = ""
        }
        
        /// Routepoint description
        if elementName == "desc" && routepoint != nil {
            currentString = ""
        }
        /// Waypoint
        if elementName == "wpt" {
            if waypoint == nil {
                waypoint = Waypoint()
                waypoint?.latitude = Double(attributeDict["lat"] ?? "0.0") ?? 0.0
                waypoint?.longitude = Double(attributeDict["lon"] ?? "0.0") ?? 0.0
            }
        }
        
        /// Waypoint name
        if elementName == "name" && waypoint != nil {
            currentString = ""
        }
        
        /// Waypoint description
        if elementName == "desc" && waypoint != nil {
            currentString = ""
        }
    }
    
    // MARK: - didEndElement
    
    @objc func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "gpx" && result?.metadata == nil {
            result?.metadata = metadata
            metadata = nil
            return
        }
        
        if elementName == "metadata" && metadata != nil {
            result?.metadata = metadata
            metadata = nil
            return
        }
        
        if elementName == "name" && metadata != nil {
            metadata?.name = currentString
            currentString = nil
            return
        }
        
        if elementName == "time" && metadata != nil {
            metadata?.date = currentString
            currentString = nil
            return
        }
        
        /// End track
        if elementName == "trk", let track = track {
            result?.tracks.append(track)
            trackpoint = nil
            return
        }
        
        /// End track name
        if elementName == "name", track != nil, trackpoint == nil {
            track?.name = currentString
            currentString = nil
        }
        
        /// End track point
        if elementName == "trkpt", let trackpoint = trackpoint, track != nil {
            track?.points.append(trackpoint)
            self.trackpoint = nil
            return
        }
        /// End route
        if elementName == "rte", let route = route {
            result?.routes.append(route)
            self.route = nil
            return
        }
        
        /// End route name
        if elementName == "name", route != nil, routepoint == nil {
            route?.name = currentString
            currentString = nil
        }
        
        /// End route point
        if elementName == "rtept", let routepoint = routepoint, route != nil {
            route?.points.append(routepoint)
            self.routepoint = nil
            return
        }
        
        /// Route point name
        if elementName == "name", routepoint != nil, let currentString = currentString {
            routepoint?.name = currentString
            self.currentString = nil
        }
        
        /// Route point description
        if elementName == "desc", routepoint != nil, let currentString = currentString {
            routepoint?.desc = currentString
            self.currentString = nil
        }
        /// End waypoint
        if elementName == "wpt", let waypoint = waypoint {
            result?.waypoints.append(waypoint)
            self.waypoint = nil
            return
        }
        
        /// Waypoint name
        if elementName == "name", waypoint != nil, let currentString = currentString {
            waypoint?.name = currentString
            self.currentString = nil
        }
        
        /// Waypoint description
        if elementName == "desc", waypoint != nil, let currentString = currentString {
            waypoint?.desc = currentString
            self.currentString = nil
        }
    }
    
    // MARK: - Conversion
    
    public override func finalizeParsing() {
        guard let result = result else {
            return
        }
        
        result.tracks = process(objects: result.tracks)
        result.routes = process(objects: result.routes)
    }
    
    private func process<T: PointsRepresentable>(objects: [T]) -> [T] {
        var processed = [T]()
        for var object in objects {
            
            var distance = 0.0
            var hasRegion = false
            var topLeftCoord: Coordinate = Point()
            var bottomRightCoord: Coordinate = Point()
            
            for index in 0..<object.points.count {
                let coordinate = object.points[index]
                
                /// Set track bounds
                if !hasRegion {
                    topLeftCoord = coordinate
                    bottomRightCoord = coordinate
                    hasRegion = true
                } else {
                    topLeftCoord.longitude = min(topLeftCoord.longitude, coordinate.longitude)
                    topLeftCoord.latitude = max(topLeftCoord.latitude, coordinate.latitude)
                    bottomRightCoord.longitude = max(bottomRightCoord.longitude, coordinate.longitude)
                    bottomRightCoord.latitude = min(bottomRightCoord.latitude, coordinate.latitude)
                }
                
                if index != 0 {
                    let previous = object.points[index - 1]
                    distance += haversineDinstance(firstCoordinate: coordinate, secondCoordinate: previous)
                }
            }
            object.distance = distance
            object.region = createRegion(topLeft: topLeftCoord, bottomRight: bottomRightCoord)
            processed.append(object)
        }
        return processed
    }
    
    private func createRegion(topLeft: Coordinate, bottomRight: Coordinate) -> CoordinateRegion {
        var region = CoordinateRegion()
        region.center.latitude = topLeft.latitude - (topLeft.latitude - bottomRight.latitude) * 0.5
        region.center.longitude = topLeft.longitude + (bottomRight.longitude - topLeft.longitude) * 0.5
        region.span.latitudeDelta = abs(topLeft.latitude - bottomRight.latitude)
        region.span.longitudeDelta = abs(bottomRight.longitude - topLeft.longitude)
        return region
    }
}

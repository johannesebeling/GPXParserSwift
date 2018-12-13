import MapKit

public final class GPXParser: ConcreteParser<GPX> {
    
    // MARK: - Properties
    
    var track: Track?
    var route: Route?

    var waypoint: Waypoint?
    var routepoint: Routepoint?
    var trackpoint: Trackpoint?
    var previousTrackpoint: Trackpoint?
    
    // MARK: - XML Parser
    
    @objc func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        /// Track
        if elementName == "trk" {
            if track == nil {
                track = Track()
            }
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
        }
        
        /// Route point
        if elementName == "rtept" && route != nil {
            if routepoint == nil {
                routepoint = Routepoint()
                routepoint?.latitude = Double(attributeDict["lat"] ?? "0.0") ?? 0.0
                routepoint?.longitude = Double(attributeDict["lon"] ?? "0.0") ?? 0.0
            }
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
    
    @objc func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        /// End track
        if elementName == "trk", let track = track {
            result?.tracks.append(track)
            trackpoint = nil
            return
        }
        
        /// End track point
        if elementName == "trkpt", let trackpoint = trackpoint, track != nil {
            track?.trackpoints.append(trackpoint)
            self.trackpoint = nil
            return
        }
        
        /// End route
        if elementName == "rte", let route = route {
            result?.routes.append(route)
            self.route = nil
            return
        }
        
        /// End route point
        if elementName == "rtept", let routepoint = routepoint, route != nil {
            route?.routepoints.append(routepoint)
            self.trackpoint = nil
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

    private func generatePaths() {
        guard let result = result else {
            return
        }
        var topLeftCoord = CLLocationCoordinate2D()
        var bottomRightCoord = CLLocationCoordinate2D()

        var hasRegion = false

        /// Fill the tracks
        for track in result.tracks {
            var coordinates = [CLLocationCoordinate2D]()
            for index in 0..<track.trackpoints.count {
                let fix = track.trackpoints[index]
                let coordinate = fix.coordinate
                coordinates.append(coordinate)

                /// Set map bounds

                if !hasRegion {
                    topLeftCoord = coordinate
                    bottomRightCoord = coordinate
                    hasRegion = true
                } else {
                    topLeftCoord.longitude = min(topLeftCoord.longitude, coordinate.longitude)
                    topLeftCoord.latitude = max(topLeftCoord.latitude, coordinate.latitude)

                    bottomRightCoord.longitude = min(bottomRightCoord.longitude, coordinate.longitude)
                    bottomRightCoord.latitude = max(bottomRightCoord.latitude, coordinate.latitude)
                }

                if let previousFix = previousTrackpoint {
                    let locCoordinate = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    let locPreviousFix = CLLocation(latitude: previousFix.coordinate.latitude, longitude: previousFix.coordinate.longitude)
                    result.distance += locCoordinate.distance(from: locPreviousFix) / 1000
                } else {
                    result.distance = 0.0
                }
                previousTrackpoint = fix
            }
            track.path = MKPolyline(coordinates: coordinates, count: track.trackpoints.count)
        }

        /// Take waypoints into account
        for index in 0..<result.waypoints.count {
            let waypoint = result.waypoints[index]
            let coordinate = waypoint.coordinate

            /// Set map bounds
            if !hasRegion {
                topLeftCoord = coordinate
                bottomRightCoord = coordinate
                hasRegion = true
            } else {
                topLeftCoord.longitude = min(topLeftCoord.longitude, coordinate.longitude)
                topLeftCoord.latitude = max(topLeftCoord.latitude, coordinate.latitude)

                bottomRightCoord.longitude = min(bottomRightCoord.longitude, coordinate.longitude)
                bottomRightCoord.latitude = max(bottomRightCoord.latitude, coordinate.latitude)
            }
        }

        /// Fill the routes
        for route in result.routes {
            var coordinates = [CLLocationCoordinate2D]()
            for index in 0..<route.routepoints.count {
                let fix = route.routepoints[index]
                let coordinate = fix.coordinate
                coordinates.append(coordinate)

                /// Set map bounds

                if !hasRegion {
                    topLeftCoord = coordinate
                    bottomRightCoord = coordinate
                    hasRegion = true
                } else {
                    topLeftCoord.longitude = min(topLeftCoord.longitude, coordinate.longitude)
                    topLeftCoord.latitude = max(topLeftCoord.latitude, coordinate.latitude)

                    bottomRightCoord.longitude = min(bottomRightCoord.longitude, coordinate.longitude)
                    bottomRightCoord.latitude = max(bottomRightCoord.latitude, coordinate.latitude)
                }
                route.path = MKPolyline(coordinates: coordinates, count: route.routepoints.count)
            }
        }
        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = abs(topLeftCoord.latitude - bottomRightCoord.latitude)
        region.span.longitudeDelta = abs(bottomRightCoord.longitude - topLeftCoord.longitude)
        result.region = region
    }
}

import MapKit

public class Parser: NSObject, XMLParserDelegate {
    public typealias GPXResponse = (_ gpx: GPX?) -> Void
    
    var gpx: GPX?
    var currentString: String?
    var track: Track?
    var route: Track?
    var waypoint: Waypoint?
    
    var fix: Fix?
    var previousFix: Fix?
    
    var completion: GPXResponse?
    
    public final func parse(url: URL, onCompletion completion: @escaping GPXResponse) {
        guard let data = try? Data(contentsOf: url) else {
            completion(nil)
            return
        }
        parse(data: data, onCompletion: completion)
    }
    
    public final func parse(data: Data, onCompletion completion: @escaping GPXResponse) {
        self.completion = completion
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    // MARK: - XML Parser
    
    @objc func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentString == nil {
            currentString = ""
        }
        currentString?.append(string)
    }
    
    @objc func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        DispatchQueue.main.async {
            self.completion?(nil)
        }
    }
    
    @objc func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        DispatchQueue.main.async {
            self.completion?(nil)
        }
    }
    
    @objc func parserDidStartDocument(_ parser: XMLParser) {
        gpx = GPX()
    }
    
    @objc func parserDidEndDocument(_ parser: XMLParser) {
        generatePaths()
        DispatchQueue.main.async {
            self.completion?(self.gpx)
        }
    }
    
    // MARK: - Conversion
    
    private func generatePaths() {
        guard let gpx = gpx else {
            return
        }
        var topLeftCoord = CLLocationCoordinate2D()
        var bottomRightCoord = CLLocationCoordinate2D()
        
        var hasRegion = false
        
        /// Fill the tracks
        for track in gpx.tracks {
            var coordinates = [CLLocationCoordinate2D]()
            for index in 0..<track.fixes.count {
                let fix = track.fixes[index]
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
                
                if let previousFix = previousFix {
                    let locCoordinate = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    let locPreviousFix = CLLocation(latitude: previousFix.coordinate.latitude, longitude: previousFix.coordinate.longitude)
                    gpx.distance += locCoordinate.distance(from: locPreviousFix) / 1000
                } else {
                    gpx.distance = 0.0
                }
                previousFix = fix
            }
            track.path = MKPolyline(coordinates: coordinates, count: track.fixes.count)
            track.shadowPath = MKPolyline(coordinates: coordinates, count: track.fixes.count)
        }
        
        /// Take waypoints into account
        for index in 0..<gpx.waypoints.count {
            let waypoint = gpx.waypoints[index]
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
        for route in gpx.routes {
            var coordinates = [CLLocationCoordinate2D]()
            for index in 0..<route.fixes.count {
                let fix = route.fixes[index]
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
                route.path = MKPolyline(coordinates: coordinates, count: route.fixes.count)
                route.shadowPath = MKPolyline(coordinates: coordinates, count: route.fixes.count)
            }
        }
        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = abs(topLeftCoord.latitude - bottomRightCoord.latitude)
        region.span.longitudeDelta = abs(bottomRightCoord.longitude - topLeftCoord.longitude)
        gpx.region = region
    }
}

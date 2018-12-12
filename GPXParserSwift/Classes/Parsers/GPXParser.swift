import Foundation

public class GPXParser: Parser {
    
    // MARK: - XML Parser
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        /// Track
        if elementName == "trk" {
            if track == nil {
                track = Track()
            }
        }
        
        /// Track point
        if elementName == "trkpt" && track != nil {
            if fix == nil {
                fix = Fix()
                fix?.latitude = Double(attributeDict["lat"] ?? "0.0") ?? 0.0
                fix?.longitude = Double(attributeDict["lon"] ?? "0.0") ?? 0.0
            }
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
        
        /// Route
        if elementName == "rte" {
            if route == nil {
                route = Track()
            }
        }
        
        /// Route point
        if elementName == "rtept" && route != nil {
            if fix == nil {
                fix = Fix()
                fix?.latitude = Double(attributeDict["lat"] ?? "0.0") ?? 0.0
                fix?.longitude = Double(attributeDict["lon"] ?? "0.0") ?? 0.0
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        /// End track
        if elementName == "trk", let track = track {
            gpx?.tracks.append(track)
            fix = nil
            return
        }
        
        /// End track point
        if elementName == "trkpt", let fix = fix, track != nil {
            track?.fixes.append(fix)
            self.fix = nil
            return
        }
        
        /// Waypoint name
        if elementName == "name", waypoint != nil, let currentString = currentString {
            waypoint?.desc = currentString
            self.currentString = nil
        }
        
        /// Waypoint description
        if elementName == "desc", waypoint != nil, let currentString = currentString {
            waypoint?.name = currentString
            self.currentString = nil
        }
        
        /// End waypoint
        if elementName == "wpt", let waypoint = waypoint {
            gpx?.waypoints.append(waypoint)
            self.waypoint = nil
            return
        }
        
        /// Route point name
        
        /// Route point description
        
        /// End route
        if elementName == "rte", let route = route {
            gpx?.routes.append(route)
            self.route = nil
            return
        }
        
        /// End route point
        if elementName == "rtept", let fix = fix, route != nil {
            route?.fixes.append(fix)
            self.fix = nil
            return
        }
    }
}

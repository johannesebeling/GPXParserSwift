import Foundation

public struct Track: Codable, PointsRepresentable {
    
    public var name: String?
    public var distance = 0.0
    public var region = CoordinateRegion()
    public var points = [Trackpoint]()
}

extension Track {
    
    public var description: String {
        var base = "Track: \(name ?? "")\n"
        base.append("Distance: \(distance)\n")
        base.append("Region:\n")
        base.append("\(region.description)\n")
        base.append("Trackpoints:\n")
        for index in 0..<points.count {
            let trackpoint = points[index]
            base.append("\(index):\n")
            base.append(trackpoint.description)
            base.append("\n")
        }
        return base
    }
}

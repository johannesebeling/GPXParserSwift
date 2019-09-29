import Foundation

public struct Route: Codable, PointsRepresentable {
    
    public var name: String?
    public var distance = 0.0
    public var region = CoordinateRegion()
    public var points = [Routepoint]()
}

extension Route {
    
    public var description: String {
        var base = "Route: \(name ?? "")\n"
        base.append("Routepoints:\n")
        for index in 0..<points.count {
            let routepoint = points[index]
            base.append("\(index):\n")
            base.append(routepoint.description)
            base.append("\n")
        }
        return base
    }
}

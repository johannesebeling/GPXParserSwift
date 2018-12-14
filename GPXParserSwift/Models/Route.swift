public struct Route {
    
    public var name: String?
    public var routepoints = [Routepoint]()
}

extension Route {
    
    public var description: String {
        var base = "Route: \(name ?? "")\n"
        base.append("Routepoints:\n")
        for index in 0..<routepoints.count {
            let routepoint = routepoints[index]
            base.append("\(index):\n")
            base.append(routepoint.description)
            base.append("\n")
        }
        return base
    }
}

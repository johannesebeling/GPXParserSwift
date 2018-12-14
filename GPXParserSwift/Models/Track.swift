public struct Track {
    
    public var name: String?
    public var trackpoints = [Trackpoint]()
}

extension Track {
    
    public var description: String {
        var base = "Track:\n"
        base.append("Name: \(name ?? "")")
        base.append("Trackpoints:\n")
        for index in 0..<trackpoints.count {
            let trackpoint = trackpoints[index]
            base.append("\(index):\n")
            base.append(trackpoint.description)
            base.append("\n")
        }
        return base
    }
}

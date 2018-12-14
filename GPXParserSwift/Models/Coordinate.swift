public protocol Coordinate {
    
    var latitude: Double { get set }
    var longitude: Double { get set }
    
    init()
}

extension Coordinate {
    
    public var description: String {
        return "Coordinate: \(latitude), \(longitude)"
    }
}

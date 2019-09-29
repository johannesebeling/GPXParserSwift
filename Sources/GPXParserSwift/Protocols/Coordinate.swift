import Foundation

public protocol Coordinate: Codable {
    
    var latitude: Double { get set }
    var longitude: Double { get set }
    
    init()
    
    init(latitude: Double, longitude: Double)
}

extension Coordinate {
    
    public var description: String {
        return "Coordinate: \(latitude), \(longitude)"
    }
}

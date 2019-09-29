import Foundation

public protocol PointsRepresentable {
    associatedtype T: Coordinate
    
    var points: [T] { get set }
    var distance: Double { get set }
    var region: CoordinateRegion { get set }
}

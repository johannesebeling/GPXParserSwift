public struct CoordinateRegion {
    
    public var center: Coordinate
    public var span: CoordinateSpan
    
    public init() {
        self.init(center: Point(), span: CoordinateSpan())
    }
    
    public init(center: Coordinate, span: CoordinateSpan) {
        self.center = center
        self.span = span
    }
}

extension CoordinateRegion {
    
    public var description: String {
        return """
        \(center.description)
        \(span.description)
        """
    }
}

public struct CoordinateRegion: Codable {
    
    public var center: Point
    public var span: CoordinateSpan
    
    public init() {
        self.init(center: Point(), span: CoordinateSpan())
    }
    
    public init(center: Point, span: CoordinateSpan) {
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

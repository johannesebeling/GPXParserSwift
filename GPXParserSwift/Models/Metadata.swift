public struct Metadata {
    
    public var creator: String?
    public var name: String?
    public var author: String?
    public var link: String?
    public var date: String?
    
}

extension Metadata {
    
    public var description: String {
        return """
        Creator: \(String(describing: creator))
        Name: \(String(describing: name))
        Author: \(String(describing: author))
        Link: \(String(describing: link))
        Date: \(String(describing: date))
        """
    }
}

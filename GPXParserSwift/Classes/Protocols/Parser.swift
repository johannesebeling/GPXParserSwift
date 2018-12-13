public protocol Parser: class, XMLParserDelegate {
    associatedtype T: Response
    typealias CompletionHandler = (_ response: T?) -> Void
    
    var currentString: String? { get set }
    
    var result: T? { get set }
    var completion: CompletionHandler? { get set }
    
    init()
    
    func parse(url: URL, onCompletion completion: @escaping CompletionHandler)
    func parse(data: Data, onCompletion completion: @escaping CompletionHandler)
}

extension Parser {
    
    // MARK: - Parsing
    
    public func parse(url: URL, onCompletion completion: @escaping CompletionHandler) {
        guard let data = try? Data(contentsOf: url) else {
            completion(nil)
            return
        }
        parse(data: data, onCompletion: completion)
    }
    
    public func parse(data: Data, onCompletion completion: @escaping CompletionHandler) {
        self.completion = completion
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
}

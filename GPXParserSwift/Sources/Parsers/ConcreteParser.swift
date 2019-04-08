import Foundation

public class ConcreteParser<K: Response>: NSObject, Parser {
    public typealias T = K
    
    // MARK: - Parser protocol
    
    public var currentString: String?
    public var result: K?
    public var completion: ((K?) -> Void)?
    
    // MARK: - Initializer
    
    override required public init() {}
    
    // MARK: - XMLParser Delegate
    
    @objc public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentString == nil {
            currentString = ""
        }
        currentString?.append(string)
    }
    
    @objc public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        DispatchQueue.main.async {
            self.completion?(nil)
        }
    }
    
    @objc public func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        DispatchQueue.main.async {
            self.completion?(nil)
        }
    }
    
    @objc public func parserDidStartDocument(_ parser: XMLParser) {
        result = T()
    }

    @objc public func parserDidEndDocument(_ parser: XMLParser) {
        finalizeParsing()
        DispatchQueue.main.async {
            self.completion?(self.result)
        }
    }
    
    public func finalizeParsing() {
        /// Do nothing
    }
}

public class Waypoint: Fix {
    
    // MARK: - Fix protocol
    
    var latitude: Double
    var longitude: Double
    
    // MARK: - Properties
    
    var name: String
    var desc: String
    
    // MARK: - Initializer
    
    init() {
        latitude = 0.0
        longitude = 0.0
        name = ""
        desc = ""
    }
}

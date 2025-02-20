import ProjectDescription

public enum BuildTarget: String {
    case dev = "DEV"
    case prod = "PROD"
}

public extension BuildTarget {
    var configurationName: ConfigurationName {
        return ConfigurationName.configuration(self.rawValue)
    }
    
    var name: String {
        self.rawValue
    }
}

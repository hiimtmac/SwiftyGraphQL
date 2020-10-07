import Foundation

public struct GQLError: Codable {
    public let message: String
    public let locations: [Location]?
    public let fields: [String]?
    public let errorType: String?
    public let validationErrorType: String?
    
    public struct Location: Codable {
        let line: Int
        let column: Int
        
        public var location: String {
            return "Ln: \(line) / Col: \(column)"
        }
    }
}

extension GQLError: Error {}
extension GQLError: LocalizedError {
    public var errorDescription: String? {
        return "Unrecoverable GraphQL© query/mutation: \(message)"
    }
    
    public var failureReason: String? {
        return errorType
    }
    
    public var recoverySuggestion: String? {
        guard let locations = locations, let fields = fields else { return nil }
        
        let locationText = locations
            .map { $0.location }
            .joined(separator: ", ")
        
        let fieldText = fields
            .map { $0 }
            .joined(separator: ", ")
        
        return "Locations: \(locationText) | Fields: \(fieldText)"
    }
}

import Foundation

extension JSONDecoder {
    public func graphQLDecode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        do {
            return try decode(type, from: data)
        } catch {
            let graphQLError = try? JSONDecoder().decode(GQLErrorSet.self, from: data)
            throw graphQLError ?? error
        }
    }
}

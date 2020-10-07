import Foundation

extension URLRequest {
    public mutating func add(_ header: HTTPHeader) {
        addValue(header.value, forHTTPHeaderField: header.name.name)
    }
    
    public mutating func add(_ headers: [HTTPHeader]) {
        headers.forEach { add($0) }
    }
    
    public mutating func set(_ header: HTTPHeader) {
        setValue(header.value, forHTTPHeaderField: header.name.name)
    }
    
    public mutating func set(_ headers: [HTTPHeader]) {
        headers.forEach { set($0) }
    }
    
    public mutating func remove(_ header: HTTPHeaderName) {
        setValue(nil, forHTTPHeaderField: header.name)
    }
    
    public static func graphql(
        url: URL,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60.0
    ) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = "POST"
        request.set(.init(.contentType, value: .json))
        request.set(.init(.accept, value: .json))
        return request
    }
}

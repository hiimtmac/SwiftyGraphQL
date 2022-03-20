// HTTPHeader.swift
// Copyright © 2022 hiimtmac

import Foundation

public struct HTTPHeader {
    public let name: HTTPHeaderName
    public let value: String

    public init(_ name: HTTPHeaderName, value: String) {
        self.name = name
        self.value = value
    }

    public init(_ name: HTTPHeaderName, value: MediaType) {
        self.name = name
        self.value = value.serialize()
    }
}

//
//  AnyCodable.swift
//  Checkout
//
//  Created by Harry Brown on 10/01/2022.
//

import Foundation

protocol AnyCodableProtocol {
  func add(customEquality: @escaping (Any, Any) -> Bool, customEncoding: @escaping (Any, inout SingleValueEncodingContainer) throws -> Bool)
}

final class AnyCodable: AnyCodableProtocol {
  func add(customEquality: @escaping (Any, Any) -> Bool, customEncoding: @escaping (Any, inout SingleValueEncodingContainer) throws -> Bool) {
    
  }
}

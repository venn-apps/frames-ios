//
//  LogManager.swift
//  
//
//  Created by Harry Brown on 10/12/2021.
//

import Foundation

protocol LogManaging {
  static func setup(
    environment: Checkout.Environment,
    uiDevice: DeviceInformationProviding,
    dateProvider: DateProviding,
    anyCodable: AnyCodableProtocol
  )
  static func queue(event: CheckoutLogEvent, completion: @escaping (() -> Void))
  static func resetCorrelationID()
  static var correlationID: String { get }
}

extension LogManaging {
  static func queue(event: CheckoutLogEvent, completion: (() -> Void)? = nil) {
    return queue(event: event, completion: completion ?? { })
  }
}

enum LogManager: LogManaging {
  private static var initialised = false
  private static var typesRegistered = false
  private static let loggingQueue = DispatchQueue(
    label: "checkout-log-store-queue",
    qos: .background,
    autoreleaseFrequency: .workItem
  )
  private static var dateProvider: DateProviding = DateProvider()
  private static var anyCodable: AnyCodableProtocol?
  private static var logsSent: Set<String> = []

  private(set) static var correlationID: String = UUID().uuidString.lowercased()

  static func resetCorrelationID() {
    loggingQueue.async {
      correlationID = UUID().uuidString.lowercased()
      logsSent = []
    }
  }

  static func setup(
    environment: Checkout.Environment,
    uiDevice: DeviceInformationProviding,
    dateProvider: DateProviding,
    anyCodable: AnyCodableProtocol
  ) {
    guard !initialised else {
      return
    }

    initialised = true

    self.dateProvider = dateProvider
    self.anyCodable = anyCodable

    registerTypes()

    let appBundle = Bundle.main
    let appPackageName = appBundle.bundleIdentifier ?? "unavailableAppPackageName"
    let appPackageVersion = appBundle
      .infoDictionary?["CFBundleShortVersionString"] as? String ?? "unavailableAppPackageVersion"

    resetCorrelationID()
  }

  static func queue(event: CheckoutLogEvent, completion: @escaping (() -> Void)) {
    let date = dateProvider.current()
    loggingQueue.async {
      completion()
    }
  }

  private static func firstTimeLogSent(id: String) -> Bool {
    return logsSent.insert(id).inserted
  }

  private static func registerTypes() {
    guard !typesRegistered || !(anyCodable is Checkout.AnyCodable) else {
      return
    }

    typesRegistered = anyCodable is Checkout.AnyCodable

    anyCodable?.add(customEquality: { lhs, rhs in
      switch (lhs, rhs) {
      case let (lhs as TokenisationError.ServerError, rhs as TokenisationError.ServerError):
        return lhs == rhs
      default:
        return false
      }
    }, customEncoding: { value, container in
      switch value {
      case let value as TokenisationError.ServerError:
        try container.encode(value)
        return true
      default:
        return false
      }
    })
  }
}

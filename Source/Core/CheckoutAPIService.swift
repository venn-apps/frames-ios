//
//  CheckoutAPIService.swift
//  
//
//  Created by Harry Brown on 03/02/2022.
//

import Foundation
import Checkout

protocol CheckoutAPIProtocol {
    var cardValidator: CardValidating { get }
    init(publicKey: String, environment: Environment)
    func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)
}

public final class CheckoutAPIService: CheckoutAPIProtocol {

    let cardValidator: CardValidating
    private let checkoutAPIService: Checkout.CheckoutAPIProtocol

    public init(publicKey: String, environment: Environment) {
        let checkoutAPIService = Checkout.CheckoutAPIService(publicKey: publicKey, environment: environment.checkoutEnvironment)
        let cardValidator = CardValidator(environment: environment.checkoutEnvironment)

        self.checkoutAPIService = checkoutAPIService
        self.cardValidator = cardValidator
    }

    public func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
        checkoutAPIService.createToken(paymentSource, completion: completion)
    }
}

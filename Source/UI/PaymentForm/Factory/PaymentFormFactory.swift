import UIKit
import Checkout

public enum PaymentFormFactory {

    public static func buildViewController(configuration: PaymentFormConfiguration,
                                           style: PaymentStyle,
                                           completionHandler: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) -> UIViewController {
        let cardValidator = CardValidator(environment: configuration.environment.checkoutEnvironment)
        let checkoutAPIService = CheckoutAPIService(publicKey: configuration.serviceAPIKey,
                                                    environment: configuration.environment)
        var viewModel = DefaultPaymentViewModel(checkoutAPIService: checkoutAPIService,
                                                cardValidator: cardValidator,
                                                billingFormData: configuration.billingFormData,
                                                paymentFormStyle: style.paymentFormStyle,
                                                billingFormStyle: style.billingFormStyle,
                                                supportedSchemes: configuration.supportedSchemes)
        viewModel.preventDuplicateCardholderInput()

        let viewController = PaymentViewController(viewModel: viewModel)
        viewModel.cardTokenRequested = completionHandler
        if #available(iOS 13.0, *) {
            viewController.isModalInPresentation = true
        }
        return viewController
    }
}

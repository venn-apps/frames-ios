import Foundation

enum FramesLogEvent: Equatable, PropertyProviding {

    enum Property: String {
        case environment
        case errorCodes
        case errorType
        case httpStatusCode
        case message
        case publicKey
        case requestID
        case scheme
        case serverError
        case tokenID
        case tokenType
        case locale
        case theme
        case primaryBackgroundColor
        case secondaryBackgroundColor
        case tertiaryBackgroundColor
        case primaryTextColor
        case secondaryTextColor
        case errorTextColor
        case chevronColor
        case font
        case barStyle
        case red
        case green
        case blue
        case alpha
        case size
        case name
        case success
    }

    case paymentFormInitialised(environment: Environment)
    case paymentFormPresented
    case paymentFormSubmitted
    case paymentFormSubmittedResult(token: String)
    case paymentFormCanceled
    case billingFormPresented
    case billingFormCanceled
    case billingFormSubmit
    case threeDSWebviewPresented
    case threeDSChallengeLoaded(success: Bool)
    case threeDSChallengeComplete(success: Bool, tokenID: String?)
    case exception(message: String)
    case warn(message: String)

    var typeIdentifier: String {
        return "com.checkout.frames-mobile-sdk.\(typeIdentifierSuffix)"
    }

    private var typeIdentifierSuffix: String {
        switch self {
        case .paymentFormInitialised:
            return "payment_form_initialised"
        case .paymentFormPresented:
            return "payment_form_presented"
        case .paymentFormSubmitted:
            return "payment_form_submitted"
        case .paymentFormSubmittedResult:
            return "payment_form_submitted_result"
        case .paymentFormCanceled:
            return "payment_form_cancelled"
        case .billingFormPresented:
            return "billing_form_presented"
        case .billingFormCanceled:
            return "billing_form_cancelled"
        case .billingFormSubmit:
            return "billing_form_submit"
        case .threeDSWebviewPresented:
            return "3ds_webview_presented"
        case .threeDSChallengeLoaded:
            return "3ds_challenge_loaded"
        case .threeDSChallengeComplete:
            return "3ds_challenge_complete"
        case .warn:
            return "warn"
        case .exception:
            return "exception"
        }
    }
}

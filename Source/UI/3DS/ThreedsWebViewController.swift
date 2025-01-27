import UIKit
import WebKit
import Checkout

/// A view controller to manage 3ds
public class ThreedsWebViewController: UIViewController {

    // MARK: - Properties

    let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        return WKWebView(frame: .zero, configuration: webConfiguration)
    }()

    /// Delegate
    public weak var delegate: ThreedsWebViewControllerDelegate?

    /// Authentication URL
    public var authURL: URL?

    private let threeDSWKNavigationHelper: ThreeDSWKNavigationHelping?

    private var webViewPresented = false
    var authUrlNavigation: WKNavigation?

    // MARK: - Initialization

    /// Initializes a web view controller adapted to handle 3dsecure.
    public convenience init(environment: Environment, successUrl: URL, failUrl: URL) {
        let threeDSWKNavigationHelper = ThreeDSWKNavigationHelperFactory().build(successURL: successUrl, failureURL: failUrl)

        self.init(threeDSWKNavigationHelper: threeDSWKNavigationHelper)
    }

    init(threeDSWKNavigationHelper: ThreeDSWKNavigationHelping) {
        self.threeDSWKNavigationHelper = threeDSWKNavigationHelper
        super.init(nibName: nil, bundle: nil)

        threeDSWKNavigationHelper.delegate = self
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Foundation.Bundle?) {
        threeDSWKNavigationHelper = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        threeDSWKNavigationHelper = nil
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Creates the view that the controller manages.
    public override func loadView() {
        view = webView
    }

    /// Called after the controller's view is loaded into memory.
    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let authURL = authURL else {
            return
        }

        let authRequest = URLRequest(url: authURL)
        webView.navigationDelegate = threeDSWKNavigationHelper
        authUrlNavigation = webView.load(authRequest)
    }
}

// MARK: - WKNavigationDelegate
extension ThreedsWebViewController: ThreeDSWKNavigationHelperDelegate {
    public func didFinishLoading(navigation: WKNavigation, success: Bool) {
        guard navigation == authUrlNavigation else {
            return
        }
    }

    public func threeDSWKNavigationHelperDelegate(didReceiveResult result: Result<String, ThreeDSError>) {
        switch result {
        case .success(let token):
            delegate?.threeDSWebViewControllerAuthenticationDidSucceed(self, token: token)
        case .failure(let error):
            switch error {
            case .couldNotExtractToken:
                delegate?.threeDSWebViewControllerAuthenticationDidSucceed(self, token: nil)
            default:
                delegate?.threeDSWebViewControllerAuthenticationDidFail(self)
            }
        }
    }
}

import XCTest
@testable import DSFSecureTextField

final class DSFSecureTextFieldTests: XCTestCase {
    func testVisibilityDefaultsToSecure() {
        XCTAssertEqual(DSFSecureTextField().visibility, .secure)
    }

    func testVisibilitySurvivesViewSetup() {
        let textField = DSFSecureTextField()
        textField.allowPasswordInPlainText = true
        textField.visibility = .plainText

        textField.viewDidMoveToWindow()

        XCTAssertEqual(textField.visibility, .plainText)
    }

    static var allTests = [
        ("testVisibilityDefaultsToSecure", testVisibilityDefaultsToSecure),
        ("testVisibilitySurvivesViewSetup", testVisibilitySurvivesViewSetup),
    ]
}

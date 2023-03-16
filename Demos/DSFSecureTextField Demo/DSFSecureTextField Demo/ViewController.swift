//
//  ViewController.swift
//  DSFSecureTextField Demo
//
//  Created by Darren Ford on 2/1/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

import Cocoa
import DSFSecureTextField

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@objc dynamic var enabled: Bool = true

	@IBOutlet weak var toggleField: DSFSecureTextField!
	@IBAction func toggled(_ sender: NSButton) {
		self.toggleField.allowPasswordInPlainText = sender.state == .on
	}

	@IBOutlet weak var showHidePasswordField: DSFSecureTextField!
	@IBAction func showHidePassword(_ sender: NSButton) {
		self.showHidePasswordField.visibility = (sender.state == .on) ? .plainText : .secure
	}

	// Detecting changes
	@objc dynamic var passwordValue: String? = nil
	@IBOutlet weak var passwordValueTextViaDelegate: NSTextField!


	@IBOutlet weak var showPasswordToggleButtonField: DSFSecureTextField!
	@objc dynamic var showPasswordToggleButton: Bool = true {
		didSet {
			self.showPasswordToggleButtonField.allowPasswordInPlainText = showPasswordToggleButton
		}
	}
}

extension ViewController: NSTextFieldDelegate {
	func controlTextDidChange(_ obj: Notification) {
		guard let s = obj.object as? NSSecureTextField else { fatalError() }
		passwordValueTextViaDelegate.stringValue = s.stringValue
	}
}

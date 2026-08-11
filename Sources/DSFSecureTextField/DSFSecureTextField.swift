//
//  DSFSecureTextField.swift
//
//  Created by Darren Ford on 2/1/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import AppKit

/// A secure text field with the ability to (optionally) show the plain text password
@MainActor
@IBDesignable
public class DSFSecureTextField: NSSecureTextField {

	@objc(DSFSecureTextFieldVisibility) public enum Visibility: Int {
		case secure = 0
		case plainText = 1
	}

	// MARK: allowPasswordInPlainText

	/// Can the password be displayed in plain text?
	@IBInspectable public dynamic var allowPasswordInPlainText: Bool = false {
		didSet {
			if self.allowPasswordInPlainText == false {
				self.visibility = .secure
			}
			self.configureButtonForVisibility()
			self.updateForPasswordVisibility()
		}
	}

	@discardableResult @inlinable
	func allowPasswordInPlainText(_ value: Bool) -> Self {
		self.allowPasswordInPlainText = value
		return self
	}

	// MARK: displayToggleButton

	/// Whether to display a toggle button into the control to control the visibility
	@IBInspectable public dynamic var displayToggleButton: Bool = true {
		didSet {
			self.updateForPasswordVisibility()
		}
	}

	@discardableResult @inlinable
	func displayToggleButton(_ value: Bool) -> Self {
		self.displayToggleButton = value
		return self
	}

	// MARK: visibility

	/// The password field visibility
	@IBInspectable public dynamic var visibility: Visibility = .secure {
		didSet {
			self.updateForPasswordVisibility()
		}
	}

	/// Set the visibility for the password field
	@discardableResult @inlinable
	func visibility(_ value: Visibility) -> Self {
		self.visibility = value
		return self
	}

	public override var isEnabled: Bool {
		didSet {
			self.visibilityButton?.isEnabled = self.isEnabled
		}
	}

	/// Set the text content for the password field
	@discardableResult @inlinable
	func text(_ value: String) -> Self {
		self.stringValue = value
		return self
	}

	// MARK: - Constructors

	override public init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override public func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		self.setup()
	}

	// Private

	// Embedded button if the style requires it
	private var visibilityButton: DSFPasswordButton?
}

// MARK: - Private (DSFSecureTextField)

@MainActor
private extension DSFSecureTextField {
	func configureButtonForVisibility() {

		self.visibilityButton?.removeFromSuperview()
		self.visibilityButton = nil

		if self.allowPasswordInPlainText, self.displayToggleButton {
			let button = DSFPasswordButton()

			self.visibilityButton = button
			button.action = #selector(self.visibilityChanged(_:))
			button.target = self
			self.addSubview(button)

			button.addConstraint(
				NSLayoutConstraint(
					item: button, attribute: .width,
					relatedBy: .equal,
					toItem: button, attribute: .height,
					multiplier: 1, constant: 0
				)
			)

			self.addConstraint(
				NSLayoutConstraint(
					item: button, attribute: .centerY,
					relatedBy: .equal,
					toItem: self, attribute: .centerY,
					multiplier: 1, constant: 0
				))
			self.addConstraint(
				NSLayoutConstraint(
					item: button, attribute: .trailing,
					relatedBy: .equal,
					toItem: self, attribute: .trailing,
					multiplier: 1, constant: -4
				))

			self.addConstraint(
				NSLayoutConstraint(
					item: button, attribute: .height,
					relatedBy: .equal,
					toItem: self, attribute: .height,
					multiplier: 1, constant: 0
				)
			)
		}
		self.needsUpdateConstraints = true
		self.window?.recalculateKeyViewLoop()
	}

	func setup() {
		self.translatesAutoresizingMaskIntoConstraints = false

		self.configureButtonForVisibility()
		self.updateForPasswordVisibility()
	}

	// MARK: Updates

	// Triggered when the user clicks the embedded button
	@objc func visibilityChanged(_ sender: NSButton) {
		self.visibility = (sender.state == .on) ? .plainText : .secure
	}

	func updateForPasswordVisibility() {
		let str = self.cell?.stringValue ?? ""
		let hasFocus = self.window?.firstResponder == self.currentEditor()
		var selectedRange: NSRange? = nil

		// Make sure our button is in the correct state
		self.visibilityButton?.state = self.visibility == .plainText ? .on : .off

		if hasFocus {
			// Text field has focus.
			if let editor = self.currentEditor() as? NSTextView {
				// Save current selectedRange
				selectedRange = editor.selectedRange()
			}
			self.abortEditing()
		}

		let newCell: NSTextFieldCell!
		let oldCell: NSTextFieldCell = self.cell as! NSTextFieldCell

		if self.displayToggleButton {
			if self.allowPasswordInPlainText {
				newCell = (self.visibility == .plainText) ? DSFPlainTextFieldCell() : DSFSecureTextFieldCell()
				self.cell = newCell
			}
			else {
				newCell = NSSecureTextFieldCell()
				self.cell = newCell
			}
		}
		else {
			// Button should NOT be included
			if self.visibility == .plainText {
				newCell = NSTextFieldCell()
				self.cell = newCell
			}
			else {
				newCell = NSSecureTextFieldCell()
				self.cell = newCell
			}
		}

		newCell.isEditable = oldCell.isEditable
		newCell.isEnabled = oldCell.isEnabled
		newCell.isEditable = oldCell.isEditable
		newCell.isSelectable = oldCell.isSelectable
		newCell.placeholderString = oldCell.placeholderString
		newCell.isScrollable = oldCell.isScrollable
		newCell.isContinuous = oldCell.isContinuous
		newCell.font = oldCell.font
		newCell.isBordered = oldCell.isBordered
		newCell.isBezeled = oldCell.isBezeled
		newCell.backgroundStyle = oldCell.backgroundStyle
		newCell.bezelStyle = oldCell.bezelStyle
		newCell.drawsBackground = oldCell.drawsBackground
		newCell.alignment = oldCell.alignment
		newCell.formatter = oldCell.formatter
		newCell.alignment = oldCell.alignment
		newCell.stringValue = oldCell.stringValue
		newCell.controlSize = oldCell.controlSize

		self.cell?.stringValue = str

		self.visibilityButton?.needsLayout = true
		self.needsUpdateConstraints = true
		self.needsLayout = true
		self.needsDisplay = true

		if hasFocus {
			self.window?.makeFirstResponder(self)
			if let selectedRange, let editor = self.currentEditor() as? NSTextView {
				editor.setSelectedRange(selectedRange)
			}
		}
	}
}

// MARK: - Private implementation (Text Field Cells)

@usableFromInline internal let __rightPadding = 32.0
@inlinable internal func __tweak(_ cell: NSTextFieldCell, _ rect: NSRect) -> NSRect {
	var newRect = rect
	newRect.size.width -= __rightPadding
	if cell.userInterfaceLayoutDirection == .rightToLeft { newRect.origin.x += __rightPadding }
	return newRect
}

@MainActor
private class DSFSecureTextFieldCell: NSSecureTextFieldCell {
	override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
		super.select(withFrame: __tweak(self, rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
	}
	override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
		super.edit(withFrame: __tweak(self, rect), in: controlView, editor: textObj, delegate: delegate, event: event)
	}
	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		if self.drawsBackground {
			NSColor.controlBackgroundColor.setFill()
			cellFrame.fill()
		}
		super.drawInterior(withFrame: __tweak(self, cellFrame), in: controlView)
	}
}

@MainActor
private class DSFPlainTextFieldCell: NSTextFieldCell {
	override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
		super.select(withFrame: __tweak(self, rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
	}
	override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
		super.edit(withFrame: __tweak(self, rect), in: controlView, editor: textObj, delegate: delegate, event: event)
	}
	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		if self.drawsBackground {
			NSColor.controlBackgroundColor.setFill()
			cellFrame.fill()
		}
		super.drawInterior(withFrame: __tweak(self, cellFrame), in: controlView)
	}
}

// MARK: - Previews

#if DEBUG

@available(macOS 14, *)
#Preview("default secure text") {
	DSFSecureTextField()
}

@available(macOS 14, *)
#Preview("no toggle") {
	DSFSecureTextField()
		.text("field without toggle button")
}

@available(macOS 14, *)
#Preview("show toggle") {
	DSFSecureTextField()
		.allowPasswordInPlainText(true)
		.displayToggleButton(true)
		.text("Show toggle button")
}

@available(macOS 14, *)
#Preview("show toggle 2") {
	DSFSecureTextField()
		.allowPasswordInPlainText(false)
		.displayToggleButton(true)
		.text("Show toggle button")
}

@available(macOS 14, *)
#Preview("default plain text") {
	DSFSecureTextField()
		.visibility(.plainText)         // By default, show the plain text
		.allowPasswordInPlainText(true)
		.displayToggleButton(true)
		.text("default plain text")
}

#endif

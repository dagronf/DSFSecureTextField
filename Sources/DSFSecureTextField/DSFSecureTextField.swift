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

public class DSFSecureTextField: NSSecureTextField {
	@objc private dynamic var showsPassword: Bool = false {
		didSet {
			update()
		}
	}

	private var visibilityButton = DSFPasswordButton(frame: NSRect(x: 0, y: 0, width: 16, height: 16))

	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	public override func awakeFromNib() {
		super.awakeFromNib()
		self.setup()
	}

	private func setup() {
		self.showsPassword = false

		self.translatesAutoresizingMaskIntoConstraints = false
		self.visibilityButton.action = #selector(visibilityChanged(_:))
		self.visibilityButton.target = self
		self.addSubview(self.visibilityButton)

	 self.addConstraint(
		 NSLayoutConstraint(
			item: self.visibilityButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
		self.addConstraint(
			NSLayoutConstraint(
			  item: self.visibilityButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))

		self.visibilityButton.addConstraint(
			NSLayoutConstraint(
				item: self.visibilityButton, attribute: .width, relatedBy: .equal, toItem: self.visibilityButton, attribute: .height, multiplier: 1, constant: 0
			)
		)

		self.addConstraint(
			NSLayoutConstraint(
		 		item: self.visibilityButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		self.addConstraint(
			NSLayoutConstraint(
				item: self.visibilityButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -2))

		self.visibilityButton.needsLayout = true
		self.needsUpdateConstraints = true

		self.update()
	}

	// MARK: Updates

	// Triggered when the user clicks the embedded button
	@objc private func visibilityChanged(_ sender: NSButton) {
		self.showsPassword = (sender.state == .on)
	}

	private func update() {
		let str = self.cell?.stringValue ?? ""

		if self.window?.firstResponder == self.currentEditor() {
			// Text field has focus.
			self.abortEditing()
		}

		let oldCell: NSTextFieldCell = self.cell as! NSTextFieldCell

		let newCell = self.showsPassword ? DSFPlainTextFieldCell() : DSFPasswordTextFieldCell()
		newCell.isEditable = true
		newCell.placeholderString = oldCell.placeholderString
		newCell.isScrollable = true
		newCell.font = oldCell.font
		newCell.isBordered = oldCell.isBordered
		newCell.isBezeled = oldCell.isBezeled
		newCell.backgroundStyle = oldCell.backgroundStyle
		newCell.bezelStyle = oldCell.bezelStyle
		newCell.drawsBackground = oldCell.drawsBackground
		self.cell = newCell

		self.cell?.stringValue = str

		self.visibilityButton.needsLayout = true
		self.needsUpdateConstraints = true
	}
}

// MARK: - Private implementation

private class DSFPasswordTextFieldCell: NSSecureTextFieldCell {
	override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
		var newRect = rect
		newRect.size.width -= rect.height * 1.25
		super.select(withFrame: newRect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
	}

	override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
		var newRect = rect
		newRect.size.width -= rect.height * 1.25
		super.edit(withFrame: newRect, in: controlView, editor: textObj, delegate: delegate, event: event)
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {

		if self.drawsBackground {
			NSColor.controlBackgroundColor.setFill()
			cellFrame.fill()
		}

		var newRect = cellFrame
		newRect.size.width -= cellFrame.height * 1.25
		super.drawInterior(withFrame: newRect, in: controlView)
	}
}

private class DSFPlainTextFieldCell: NSTextFieldCell {
	override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
		var newRect = rect
		newRect.size.width -= rect.height * 1.25
		super.select(withFrame: newRect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
	}

	override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
		var newRect = rect
		newRect.size.width -= rect.height * 1.25
		super.edit(withFrame: newRect, in: controlView, editor: textObj, delegate: delegate, event: event)
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		if self.drawsBackground {
			NSColor.controlBackgroundColor.setFill()
			cellFrame.fill()
		}

		var newRect = cellFrame
		newRect.size.width -= cellFrame.height * 1.25
		super.drawInterior(withFrame: newRect, in: controlView)
	}
}

private class DSFPasswordButton: NSButton {

	private class Translation {
		static var toggle: String {
			NSLocalizedString("Toggle password visibility", comment: "Button used to toggle whether the password is shown in the clear or obscured")
		}
	}

	// State observer for the button. Note that we have to attach it to the _cell's_ state, as the NSButton state is not
	// marked as `dynamic` in Swift.
	private var stateObserver: NSKeyValueObservation?

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setup()
	}

	override var cell: NSCell? {
		get {
			super.cell
		}
		set {
			super.cell = newValue
			self.updateObserver()
		}
	}

	private func updateObserver() {
		self.stateObserver = nil
		self.stateObserver = self.observe(\.cell!.state, options: [.new]) { [weak self] (button, state) in
			self?.stateChanged()
		}
	}

	private func stateChanged() {
		// Currently doing nothing
	}

	private func setup() {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.isBordered = false
		self.imagePosition = .noImage

		self.toolTip = Translation.toggle

		// Initial observer
		self.updateObserver()
	}


	// MARK: Tracking areas

	private var trackingArea: NSTrackingArea?

	override func layout() {
		super.layout()

		if let e = trackingArea {
			self.removeTrackingArea(e)
		}

		let opts: NSTrackingArea.Options = [.inVisibleRect, [.mouseMoved, .mouseEnteredAndExited], .activeInKeyWindow]
		let newE = NSTrackingArea(rect: self.bounds, options: opts, owner: self, userInfo: nil)
		self.addTrackingArea(newE)
	}

	override func mouseMoved(with event: NSEvent) {
		super.mouseMoved(with: event)
		NSCursor.pointingHand.set()
	}

	override public func mouseEntered(with event: NSEvent) {
		NSCursor.pointingHand.set()
	}

	override public func mouseExited(with event: NSEvent) {
		NSCursor.arrow.set()
	}

	// MARK: Drawing

	override func draw(_ dirtyRect: NSRect) {
		let dest = self.bounds

		let highContrast = NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast

		if state == .on {

			let fillColor = NSColor.red

			//// Bezier Drawing
			let bezierPath = NSBezierPath()
			bezierPath.move(to: NSPoint(x: 25.12, y: 5.21))
			bezierPath.line(to: NSPoint(x: 6.03, y: 24.46))
			bezierPath.curve(to: NSPoint(x: 6.03, y: 25.42), controlPoint1: NSPoint(x: 5.77, y: 24.72), controlPoint2: NSPoint(x: 5.77, y: 25.16))
			bezierPath.curve(to: NSPoint(x: 6.99, y: 25.42), controlPoint1: NSPoint(x: 6.3, y: 25.7), controlPoint2: NSPoint(x: 6.73, y: 25.69))
			bezierPath.line(to: NSPoint(x: 26.06, y: 6.17))
			bezierPath.curve(to: NSPoint(x: 26.06, y: 5.21), controlPoint1: NSPoint(x: 26.34, y: 5.9), controlPoint2: NSPoint(x: 26.36, y: 5.51))
			bezierPath.curve(to: NSPoint(x: 25.12, y: 5.21), controlPoint1: NSPoint(x: 25.79, y: 4.92), controlPoint2: NSPoint(x: 25.38, y: 4.94))
			bezierPath.close()
			bezierPath.move(to: NSPoint(x: 16.14, y: 24.73))
			bezierPath.curve(to: NSPoint(x: 31.27, y: 15.08), controlPoint1: NSPoint(x: 25.03, y: 24.73), controlPoint2: NSPoint(x: 31.27, y: 17.37))
			bezierPath.curve(to: NSPoint(x: 25.43, y: 8.27), controlPoint1: NSPoint(x: 31.27, y: 13.72), controlPoint2: NSPoint(x: 29.09, y: 10.59))
			bezierPath.line(to: NSPoint(x: 24.35, y: 9.36))
			bezierPath.curve(to: NSPoint(x: 29.73, y: 15.08), controlPoint1: NSPoint(x: 27.67, y: 11.38), controlPoint2: NSPoint(x: 29.73, y: 14.09))
			bezierPath.curve(to: NSPoint(x: 16.14, y: 23.31), controlPoint1: NSPoint(x: 29.73, y: 16.58), controlPoint2: NSPoint(x: 23.83, y: 23.31))
			bezierPath.curve(to: NSPoint(x: 11.7, y: 22.53), controlPoint1: NSPoint(x: 14.51, y: 23.31), controlPoint2: NSPoint(x: 13.1, y: 23.02))
			bezierPath.line(to: NSPoint(x: 10.54, y: 23.69))
			bezierPath.curve(to: NSPoint(x: 16.14, y: 24.73), controlPoint1: NSPoint(x: 12.28, y: 24.33), controlPoint2: NSPoint(x: 14.07, y: 24.73))
			bezierPath.close()
			bezierPath.move(to: NSPoint(x: 16.14, y: 5.43))
			bezierPath.curve(to: NSPoint(x: 1, y: 15.08), controlPoint1: NSPoint(x: 7.33, y: 5.43), controlPoint2: NSPoint(x: 1, y: 12.79))
			bezierPath.curve(to: NSPoint(x: 7.04, y: 21.99), controlPoint1: NSPoint(x: 1, y: 16.45), controlPoint2: NSPoint(x: 3.27, y: 19.64))
			bezierPath.line(to: NSPoint(x: 8.14, y: 20.88))
			bezierPath.curve(to: NSPoint(x: 2.56, y: 15.08), controlPoint1: NSPoint(x: 4.68, y: 18.8), controlPoint2: NSPoint(x: 2.56, y: 15.99))
			bezierPath.curve(to: NSPoint(x: 16.14, y: 6.85), controlPoint1: NSPoint(x: 2.56, y: 13.4), controlPoint2: NSPoint(x: 8.48, y: 6.85))
			bezierPath.curve(to: NSPoint(x: 20.89, y: 7.68), controlPoint1: NSPoint(x: 17.87, y: 6.85), controlPoint2: NSPoint(x: 19.41, y: 7.17))
			bezierPath.line(to: NSPoint(x: 22.04, y: 6.51))
			bezierPath.curve(to: NSPoint(x: 16.14, y: 5.43), controlPoint1: NSPoint(x: 20.25, y: 5.85), controlPoint2: NSPoint(x: 18.31, y: 5.43))
			bezierPath.close()
			bezierPath.move(to: NSPoint(x: 21.75, y: 12.25))
			bezierPath.line(to: NSPoint(x: 13.32, y: 20.75))
			bezierPath.curve(to: NSPoint(x: 16.14, y: 21.44), controlPoint1: NSPoint(x: 14.17, y: 21.19), controlPoint2: NSPoint(x: 15.13, y: 21.44))
			bezierPath.curve(to: NSPoint(x: 22.47, y: 15.08), controlPoint1: NSPoint(x: 19.63, y: 21.44), controlPoint2: NSPoint(x: 22.47, y: 18.63))
			bezierPath.curve(to: NSPoint(x: 21.75, y: 12.25), controlPoint1: NSPoint(x: 22.47, y: 14.06), controlPoint2: NSPoint(x: 22.21, y: 13.09))
			bezierPath.close()
			bezierPath.move(to: NSPoint(x: 16.14, y: 8.71))
			bezierPath.curve(to: NSPoint(x: 9.81, y: 15.08), controlPoint1: NSPoint(x: 12.62, y: 8.71), controlPoint2: NSPoint(x: 9.83, y: 11.61))
			bezierPath.curve(to: NSPoint(x: 10.6, y: 18.13), controlPoint1: NSPoint(x: 9.81, y: 16.19), controlPoint2: NSPoint(x: 10.09, y: 17.24))
			bezierPath.line(to: NSPoint(x: 19.13, y: 9.51))
			bezierPath.curve(to: NSPoint(x: 16.14, y: 8.71), controlPoint1: NSPoint(x: 18.25, y: 9.01), controlPoint2: NSPoint(x: 17.24, y: 8.71))
			bezierPath.close()

			var t = AffineTransform()
			t.scale(dest.width / 33.0)
			t.translate(x: 0, y: 1)
			bezierPath.transform(using: t)

			fillColor.setFill()
			bezierPath.fill()
		}
		else {
			let fillColor = NSColor.secondaryLabelColor

			let bezierPath = NSBezierPath()
			bezierPath.move(to: NSPoint(x: 16.01, y: 5))
			bezierPath.curve(to: NSPoint(x: 1, y: 15), controlPoint1: NSPoint(x: 7.27, y: 5), controlPoint2: NSPoint(x: 1, y: 12.63))
			bezierPath.curve(to: NSPoint(x: 16.01, y: 25), controlPoint1: NSPoint(x: 1, y: 17.37), controlPoint2: NSPoint(x: 7.31, y: 25))
			bezierPath.curve(to: NSPoint(x: 31, y: 15), controlPoint1: NSPoint(x: 24.78, y: 25), controlPoint2: NSPoint(x: 31, y: 17.37))
			bezierPath.curve(to: NSPoint(x: 16.01, y: 5), controlPoint1: NSPoint(x: 31, y: 12.63), controlPoint2: NSPoint(x: 24.81, y: 5))
			bezierPath.close()
			bezierPath.move(to: NSPoint(x: 16.01, y: 6.47))
			bezierPath.curve(to: NSPoint(x: 29.47, y: 15), controlPoint1: NSPoint(x: 23.59, y: 6.47), controlPoint2: NSPoint(x: 29.47, y: 13.27))
			bezierPath.curve(to: NSPoint(x: 16.01, y: 23.53), controlPoint1: NSPoint(x: 29.47, y: 16.56), controlPoint2: NSPoint(x: 23.59, y: 23.53))
			bezierPath.curve(to: NSPoint(x: 2.54, y: 15), controlPoint1: NSPoint(x: 8.41, y: 23.53), controlPoint2: NSPoint(x: 2.54, y: 16.56))
			bezierPath.curve(to: NSPoint(x: 16.01, y: 6.47), controlPoint1: NSPoint(x: 2.54, y: 13.27), controlPoint2: NSPoint(x: 8.41, y: 6.47))
			bezierPath.close()
			bezierPath.move(to: NSPoint(x: 16.01, y: 8.41))
			bezierPath.curve(to: NSPoint(x: 9.73, y: 15), controlPoint1: NSPoint(x: 12.52, y: 8.41), controlPoint2: NSPoint(x: 9.75, y: 11.4))
			bezierPath.curve(to: NSPoint(x: 16.01, y: 21.59), controlPoint1: NSPoint(x: 9.72, y: 18.68), controlPoint2: NSPoint(x: 12.52, y: 21.59))
			bezierPath.curve(to: NSPoint(x: 22.27, y: 15), controlPoint1: NSPoint(x: 19.46, y: 21.59), controlPoint2: NSPoint(x: 22.27, y: 18.68))
			bezierPath.curve(to: NSPoint(x: 16.01, y: 8.41), controlPoint1: NSPoint(x: 22.27, y: 11.4), controlPoint2: NSPoint(x: 19.46, y: 8.41))
			bezierPath.close()
			bezierPath.move(to: NSPoint(x: 16.02, y: 12.9))
			bezierPath.curve(to: NSPoint(x: 18.02, y: 15), controlPoint1: NSPoint(x: 17.11, y: 12.9), controlPoint2: NSPoint(x: 18.02, y: 13.84))
			bezierPath.curve(to: NSPoint(x: 16.02, y: 17.1), controlPoint1: NSPoint(x: 18.02, y: 16.17), controlPoint2: NSPoint(x: 17.11, y: 17.1))
			bezierPath.curve(to: NSPoint(x: 13.99, y: 15), controlPoint1: NSPoint(x: 14.9, y: 17.1), controlPoint2: NSPoint(x: 13.99, y: 16.17))
			bezierPath.curve(to: NSPoint(x: 16.02, y: 12.9), controlPoint1: NSPoint(x: 13.99, y: 13.84), controlPoint2: NSPoint(x: 14.9, y: 12.9))
			bezierPath.close()

			var t = AffineTransform()
			t.scale(dest.width / 33.0)
			t.translate(x: 0, y: 1)
			bezierPath.transform(using: t)

			if !highContrast {
				let sh = NSShadow()
				sh.shadowColor = NSColor.black.withAlphaComponent(0.6)
				sh.shadowOffset = NSSize(width: 1.0, height: -1.0)
				sh.shadowBlurRadius = 1.0
				sh.set()
			}

			fillColor.setFill()
			bezierPath.fill()
		}
	}
}



//
//  DSFPasswordButton.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import AppKit
import Foundation

// MARK: - Private implementation (Embedded button)

internal class DSFPasswordButton: NSButton {
	private enum Translation {
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
		}
	}

	private func setup() {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		self.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		self.isBordered = false
		self.imagePosition = .noImage

		self.toolTip = Translation.toggle
	}

	// MARK: Tracking areas

	private var trackingArea: NSTrackingArea?

	override func updateTrackingAreas() {
		super.updateTrackingAreas()

		if let e = self.trackingArea {
			self.removeTrackingArea(e)
		}

		let opts: NSTrackingArea.Options = [.inVisibleRect, [.mouseMoved, .mouseEnteredAndExited], .activeInKeyWindow]
		let nte = NSTrackingArea(rect: self.bounds, options: opts, owner: self, userInfo: nil)
		self.addTrackingArea(nte)
	}

	override func mouseMoved(with event: NSEvent) {
		super.mouseMoved(with: event)
		if isEnabled {
			NSCursor.pointingHand.set()
		}
	}

	override public func mouseEntered(with event: NSEvent) {
		if isEnabled {
			NSCursor.pointingHand.set()
		}
	}

	override public func mouseExited(with event: NSEvent) {
		NSCursor.arrow.set()
	}

	// MARK: Drawing

	override func draw(_ dirtyRect: NSRect) {
		// The color for the current state
		let currentColor = self.isEnabled ? NSColor.secondaryLabelColor : NSColor.disabledControlTextColor

		// The path for the current state
		let eyePath = ((state == .off) ? self.offPath : self.onPath).copy() as! NSBezierPath

		// Scale the path to fit the current bounds
		var t = AffineTransform()
		t.scale(self.bounds.width / 32.0)
		eyePath.transform(using: t)

		// And fill!
		currentColor.setFill()
		eyePath.fill()
	}

	// 32x32 icon for the 'off' state
	private let offPath: NSBezierPath = {
		//// Bezier Drawing
		let textPath = NSBezierPath()
		textPath.move(to: NSPoint(x: 15.96, y: 6.44))
		textPath.curve(to: NSPoint(x: 18.9, y: 6.69), controlPoint1: NSPoint(x: 16.98, y: 6.44), controlPoint2: NSPoint(x: 17.96, y: 6.53))
		textPath.curve(to: NSPoint(x: 21.61, y: 7.39), controlPoint1: NSPoint(x: 19.84, y: 6.86), controlPoint2: NSPoint(x: 20.74, y: 7.09))
		textPath.line(to: NSPoint(x: 19.97, y: 9.01))
		textPath.curve(to: NSPoint(x: 18.03, y: 8.56), controlPoint1: NSPoint(x: 19.34, y: 8.82), controlPoint2: NSPoint(x: 18.7, y: 8.67))
		textPath.curve(to: NSPoint(x: 15.96, y: 8.4), controlPoint1: NSPoint(x: 17.36, y: 8.45), controlPoint2: NSPoint(x: 16.67, y: 8.4))
		textPath.curve(to: NSPoint(x: 12.5, y: 8.84), controlPoint1: NSPoint(x: 14.76, y: 8.4), controlPoint2: NSPoint(x: 13.61, y: 8.55))
		textPath.curve(to: NSPoint(x: 9.4, y: 10.02), controlPoint1: NSPoint(x: 11.4, y: 9.14), controlPoint2: NSPoint(x: 10.37, y: 9.53))
		textPath.curve(to: NSPoint(x: 6.79, y: 11.61), controlPoint1: NSPoint(x: 8.44, y: 10.5), controlPoint2: NSPoint(x: 7.57, y: 11.03))
		textPath.curve(to: NSPoint(x: 4.76, y: 13.33), controlPoint1: NSPoint(x: 6, y: 12.19), controlPoint2: NSPoint(x: 5.33, y: 12.76))
		textPath.curve(to: NSPoint(x: 3.46, y: 14.9), controlPoint1: NSPoint(x: 4.2, y: 13.9), controlPoint2: NSPoint(x: 3.76, y: 14.42))
		textPath.curve(to: NSPoint(x: 3.01, y: 15.99), controlPoint1: NSPoint(x: 3.16, y: 15.37), controlPoint2: NSPoint(x: 3.01, y: 15.73))
		textPath.curve(to: NSPoint(x: 3.63, y: 17.23), controlPoint1: NSPoint(x: 3.01, y: 16.24), controlPoint2: NSPoint(x: 3.22, y: 16.65))
		textPath.curve(to: NSPoint(x: 5.4, y: 19.14), controlPoint1: NSPoint(x: 4.05, y: 17.8), controlPoint2: NSPoint(x: 4.63, y: 18.44))
		textPath.curve(to: NSPoint(x: 8.12, y: 21.15), controlPoint1: NSPoint(x: 6.16, y: 19.84), controlPoint2: NSPoint(x: 7.07, y: 20.51))
		textPath.line(to: NSPoint(x: 6.59, y: 22.68))
		textPath.curve(to: NSPoint(x: 3.45, y: 20.23), controlPoint1: NSPoint(x: 5.36, y: 21.92), controlPoint2: NSPoint(x: 4.31, y: 21.1))
		textPath.curve(to: NSPoint(x: 1.46, y: 17.8), controlPoint1: NSPoint(x: 2.59, y: 19.37), controlPoint2: NSPoint(x: 1.92, y: 18.55))
		textPath.curve(to: NSPoint(x: 0.76, y: 15.99), controlPoint1: NSPoint(x: 0.99, y: 17.04), controlPoint2: NSPoint(x: 0.76, y: 16.44))
		textPath.curve(to: NSPoint(x: 1.27, y: 14.51), controlPoint1: NSPoint(x: 0.76, y: 15.62), controlPoint2: NSPoint(x: 0.93, y: 15.12))
		textPath.curve(to: NSPoint(x: 2.72, y: 12.51), controlPoint1: NSPoint(x: 1.6, y: 13.9), controlPoint2: NSPoint(x: 2.09, y: 13.23))
		textPath.curve(to: NSPoint(x: 5.02, y: 10.37), controlPoint1: NSPoint(x: 3.35, y: 11.79), controlPoint2: NSPoint(x: 4.12, y: 11.08))
		textPath.curve(to: NSPoint(x: 8.06, y: 8.41), controlPoint1: NSPoint(x: 5.91, y: 9.66), controlPoint2: NSPoint(x: 6.93, y: 9))
		textPath.curve(to: NSPoint(x: 11.74, y: 6.98), controlPoint1: NSPoint(x: 9.19, y: 7.82), controlPoint2: NSPoint(x: 10.41, y: 7.34))
		textPath.curve(to: NSPoint(x: 15.96, y: 6.44), controlPoint1: NSPoint(x: 13.06, y: 6.62), controlPoint2: NSPoint(x: 14.47, y: 6.44))
		textPath.close()
		textPath.move(to: NSPoint(x: 15.96, y: 25.53))
		textPath.curve(to: NSPoint(x: 13.19, y: 25.3), controlPoint1: NSPoint(x: 14.99, y: 25.53), controlPoint2: NSPoint(x: 14.07, y: 25.46))
		textPath.curve(to: NSPoint(x: 10.64, y: 24.66), controlPoint1: NSPoint(x: 12.31, y: 25.15), controlPoint2: NSPoint(x: 11.46, y: 24.94))
		textPath.line(to: NSPoint(x: 12.27, y: 23.05))
		textPath.curve(to: NSPoint(x: 14.06, y: 23.45), controlPoint1: NSPoint(x: 12.86, y: 23.22), controlPoint2: NSPoint(x: 13.45, y: 23.35))
		textPath.curve(to: NSPoint(x: 15.96, y: 23.59), controlPoint1: NSPoint(x: 14.67, y: 23.54), controlPoint2: NSPoint(x: 15.3, y: 23.59))
		textPath.curve(to: NSPoint(x: 19.4, y: 23.13), controlPoint1: NSPoint(x: 17.15, y: 23.59), controlPoint2: NSPoint(x: 18.29, y: 23.43))
		textPath.curve(to: NSPoint(x: 22.5, y: 21.92), controlPoint1: NSPoint(x: 20.51, y: 22.82), controlPoint2: NSPoint(x: 21.54, y: 22.42))
		textPath.curve(to: NSPoint(x: 25.12, y: 20.28), controlPoint1: NSPoint(x: 23.46, y: 21.41), controlPoint2: NSPoint(x: 24.33, y: 20.87))
		textPath.curve(to: NSPoint(x: 27.14, y: 18.54), controlPoint1: NSPoint(x: 25.9, y: 19.7), controlPoint2: NSPoint(x: 26.58, y: 19.11))
		textPath.curve(to: NSPoint(x: 28.44, y: 16.99), controlPoint1: NSPoint(x: 27.7, y: 17.96), controlPoint2: NSPoint(x: 28.13, y: 17.44))
		textPath.curve(to: NSPoint(x: 28.89, y: 15.99), controlPoint1: NSPoint(x: 28.74, y: 16.54), controlPoint2: NSPoint(x: 28.89, y: 16.21))
		textPath.curve(to: NSPoint(x: 28.31, y: 14.7), controlPoint1: NSPoint(x: 28.89, y: 15.7), controlPoint2: NSPoint(x: 28.69, y: 15.27))
		textPath.curve(to: NSPoint(x: 26.64, y: 12.86), controlPoint1: NSPoint(x: 27.92, y: 14.14), controlPoint2: NSPoint(x: 27.37, y: 13.53))
		textPath.curve(to: NSPoint(x: 24.08, y: 10.93), controlPoint1: NSPoint(x: 25.92, y: 12.19), controlPoint2: NSPoint(x: 25.07, y: 11.55))
		textPath.line(to: NSPoint(x: 25.59, y: 9.42))
		textPath.curve(to: NSPoint(x: 28.58, y: 11.84), controlPoint1: NSPoint(x: 26.76, y: 10.18), controlPoint2: NSPoint(x: 27.75, y: 10.99))
		textPath.curve(to: NSPoint(x: 30.49, y: 14.22), controlPoint1: NSPoint(x: 29.41, y: 12.69), controlPoint2: NSPoint(x: 30.04, y: 13.48))
		textPath.curve(to: NSPoint(x: 31.15, y: 15.99), controlPoint1: NSPoint(x: 30.93, y: 14.96), controlPoint2: NSPoint(x: 31.15, y: 15.55))
		textPath.curve(to: NSPoint(x: 30.65, y: 17.47), controlPoint1: NSPoint(x: 31.15, y: 16.37), controlPoint2: NSPoint(x: 30.98, y: 16.86))
		textPath.curve(to: NSPoint(x: 29.21, y: 19.47), controlPoint1: NSPoint(x: 30.32, y: 18.09), controlPoint2: NSPoint(x: 29.84, y: 18.75))
		textPath.curve(to: NSPoint(x: 26.94, y: 21.62), controlPoint1: NSPoint(x: 28.59, y: 20.19), controlPoint2: NSPoint(x: 27.83, y: 20.91))
		textPath.curve(to: NSPoint(x: 23.91, y: 23.57), controlPoint1: NSPoint(x: 26.04, y: 22.34), controlPoint2: NSPoint(x: 25.03, y: 22.99))
		textPath.curve(to: NSPoint(x: 20.21, y: 24.99), controlPoint1: NSPoint(x: 22.78, y: 24.16), controlPoint2: NSPoint(x: 21.55, y: 24.63))
		textPath.curve(to: NSPoint(x: 15.96, y: 25.53), controlPoint1: NSPoint(x: 18.88, y: 25.35), controlPoint2: NSPoint(x: 17.46, y: 25.53))
		textPath.close()
		textPath.move(to: NSPoint(x: 15.96, y: 9.91))
		textPath.curve(to: NSPoint(x: 17.29, y: 10.06), controlPoint1: NSPoint(x: 16.42, y: 9.91), controlPoint2: NSPoint(x: 16.86, y: 9.96))
		textPath.curve(to: NSPoint(x: 18.5, y: 10.5), controlPoint1: NSPoint(x: 17.71, y: 10.16), controlPoint2: NSPoint(x: 18.11, y: 10.31))
		textPath.line(to: NSPoint(x: 10.44, y: 18.56))
		textPath.curve(to: NSPoint(x: 10, y: 17.34), controlPoint1: NSPoint(x: 10.25, y: 18.18), controlPoint2: NSPoint(x: 10.1, y: 17.77))
		textPath.curve(to: NSPoint(x: 9.86, y: 15.99), controlPoint1: NSPoint(x: 9.9, y: 16.91), controlPoint2: NSPoint(x: 9.86, y: 16.46))
		textPath.curve(to: NSPoint(x: 10.68, y: 12.96), controlPoint1: NSPoint(x: 9.86, y: 14.89), controlPoint2: NSPoint(x: 10.13, y: 13.88))
		textPath.curve(to: NSPoint(x: 12.88, y: 10.74), controlPoint1: NSPoint(x: 11.22, y: 12.04), controlPoint2: NSPoint(x: 11.96, y: 11.3))
		textPath.curve(to: NSPoint(x: 15.96, y: 9.91), controlPoint1: NSPoint(x: 13.8, y: 10.19), controlPoint2: NSPoint(x: 14.83, y: 9.91))
		textPath.close()
		textPath.move(to: NSPoint(x: 21.56, y: 13.72))
		textPath.curve(to: NSPoint(x: 21.93, y: 14.81), controlPoint1: NSPoint(x: 21.72, y: 14.06), controlPoint2: NSPoint(x: 21.84, y: 14.43))
		textPath.curve(to: NSPoint(x: 22.05, y: 15.99), controlPoint1: NSPoint(x: 22.01, y: 15.19), controlPoint2: NSPoint(x: 22.05, y: 15.59))
		textPath.curve(to: NSPoint(x: 21.23, y: 19.07), controlPoint1: NSPoint(x: 22.05, y: 17.13), controlPoint2: NSPoint(x: 21.78, y: 18.15))
		textPath.curve(to: NSPoint(x: 19.03, y: 21.25), controlPoint1: NSPoint(x: 20.69, y: 19.99), controlPoint2: NSPoint(x: 19.95, y: 20.71))
		textPath.curve(to: NSPoint(x: 15.96, y: 22.06), controlPoint1: NSPoint(x: 18.11, y: 21.79), controlPoint2: NSPoint(x: 17.09, y: 22.06))
		textPath.curve(to: NSPoint(x: 14.77, y: 21.95), controlPoint1: NSPoint(x: 15.55, y: 22.06), controlPoint2: NSPoint(x: 15.15, y: 22.02))
		textPath.curve(to: NSPoint(x: 13.68, y: 21.61), controlPoint1: NSPoint(x: 14.39, y: 21.87), controlPoint2: NSPoint(x: 14.03, y: 21.75))
		textPath.line(to: NSPoint(x: 21.56, y: 13.72))
		textPath.close()
		textPath.move(to: NSPoint(x: 24.64, y: 6.29))
		textPath.curve(to: NSPoint(x: 25.25, y: 6.03), controlPoint1: NSPoint(x: 24.82, y: 6.12), controlPoint2: NSPoint(x: 25.02, y: 6.03))
		textPath.curve(to: NSPoint(x: 25.88, y: 6.29), controlPoint1: NSPoint(x: 25.49, y: 6.02), controlPoint2: NSPoint(x: 25.7, y: 6.11))
		textPath.curve(to: NSPoint(x: 26.14, y: 6.92), controlPoint1: NSPoint(x: 26.05, y: 6.48), controlPoint2: NSPoint(x: 26.14, y: 6.69))
		textPath.curve(to: NSPoint(x: 25.88, y: 7.52), controlPoint1: NSPoint(x: 26.13, y: 7.15), controlPoint2: NSPoint(x: 26.05, y: 7.35))
		textPath.line(to: NSPoint(x: 7.22, y: 26.16))
		textPath.curve(to: NSPoint(x: 6.59, y: 26.43), controlPoint1: NSPoint(x: 7.04, y: 26.34), controlPoint2: NSPoint(x: 6.83, y: 26.43))
		textPath.curve(to: NSPoint(x: 5.98, y: 26.16), controlPoint1: NSPoint(x: 6.34, y: 26.43), controlPoint2: NSPoint(x: 6.14, y: 26.34))
		textPath.curve(to: NSPoint(x: 5.72, y: 25.56), controlPoint1: NSPoint(x: 5.8, y: 26.01), controlPoint2: NSPoint(x: 5.72, y: 25.81))
		textPath.curve(to: NSPoint(x: 5.98, y: 24.95), controlPoint1: NSPoint(x: 5.72, y: 25.31), controlPoint2: NSPoint(x: 5.8, y: 25.11))
		textPath.line(to: NSPoint(x: 24.64, y: 6.29))
		textPath.close()
		return textPath
	}()

	// 32x32 icon for the 'on' state
	private let onPath: NSBezierPath = {
		let textPath = NSBezierPath()
		textPath.move(to: NSPoint(x: 15.96, y: 6.44))
		textPath.curve(to: NSPoint(x: 20.22, y: 6.98), controlPoint1: NSPoint(x: 17.46, y: 6.44), controlPoint2: NSPoint(x: 18.88, y: 6.62))
		textPath.curve(to: NSPoint(x: 23.9, y: 8.41), controlPoint1: NSPoint(x: 21.55, y: 7.34), controlPoint2: NSPoint(x: 22.78, y: 7.82))
		textPath.curve(to: NSPoint(x: 26.93, y: 10.37), controlPoint1: NSPoint(x: 25.03, y: 9.01), controlPoint2: NSPoint(x: 26.04, y: 9.66))
		textPath.curve(to: NSPoint(x: 29.21, y: 12.51), controlPoint1: NSPoint(x: 27.83, y: 11.08), controlPoint2: NSPoint(x: 28.59, y: 11.79))
		textPath.curve(to: NSPoint(x: 30.65, y: 14.51), controlPoint1: NSPoint(x: 29.84, y: 13.23), controlPoint2: NSPoint(x: 30.32, y: 13.9))
		textPath.curve(to: NSPoint(x: 31.14, y: 15.99), controlPoint1: NSPoint(x: 30.98, y: 15.12), controlPoint2: NSPoint(x: 31.14, y: 15.62))
		textPath.curve(to: NSPoint(x: 30.65, y: 17.47), controlPoint1: NSPoint(x: 31.14, y: 16.37), controlPoint2: NSPoint(x: 30.98, y: 16.86))
		textPath.curve(to: NSPoint(x: 29.21, y: 19.47), controlPoint1: NSPoint(x: 30.32, y: 18.08), controlPoint2: NSPoint(x: 29.84, y: 18.75))
		textPath.curve(to: NSPoint(x: 26.93, y: 21.62), controlPoint1: NSPoint(x: 28.58, y: 20.19), controlPoint2: NSPoint(x: 27.82, y: 20.9))
		textPath.curve(to: NSPoint(x: 23.9, y: 23.57), controlPoint1: NSPoint(x: 26.04, y: 22.33), controlPoint2: NSPoint(x: 25.03, y: 22.98))
		textPath.curve(to: NSPoint(x: 20.21, y: 25), controlPoint1: NSPoint(x: 22.77, y: 24.16), controlPoint2: NSPoint(x: 21.54, y: 24.64))
		textPath.curve(to: NSPoint(x: 15.96, y: 25.53), controlPoint1: NSPoint(x: 18.88, y: 25.35), controlPoint2: NSPoint(x: 17.46, y: 25.53))
		textPath.curve(to: NSPoint(x: 11.74, y: 25), controlPoint1: NSPoint(x: 14.47, y: 25.53), controlPoint2: NSPoint(x: 13.06, y: 25.35))
		textPath.curve(to: NSPoint(x: 8.06, y: 23.57), controlPoint1: NSPoint(x: 10.42, y: 24.64), controlPoint2: NSPoint(x: 9.19, y: 24.16))
		textPath.curve(to: NSPoint(x: 5.02, y: 21.62), controlPoint1: NSPoint(x: 6.94, y: 22.98), controlPoint2: NSPoint(x: 5.92, y: 22.33))
		textPath.curve(to: NSPoint(x: 2.72, y: 19.47), controlPoint1: NSPoint(x: 4.12, y: 20.9), controlPoint2: NSPoint(x: 3.36, y: 20.19))
		textPath.curve(to: NSPoint(x: 1.26, y: 17.47), controlPoint1: NSPoint(x: 2.09, y: 18.75), controlPoint2: NSPoint(x: 1.6, y: 18.08))
		textPath.curve(to: NSPoint(x: 0.76, y: 15.99), controlPoint1: NSPoint(x: 0.93, y: 16.86), controlPoint2: NSPoint(x: 0.76, y: 16.37))
		textPath.curve(to: NSPoint(x: 1.26, y: 14.51), controlPoint1: NSPoint(x: 0.76, y: 15.62), controlPoint2: NSPoint(x: 0.93, y: 15.12))
		textPath.curve(to: NSPoint(x: 2.72, y: 12.51), controlPoint1: NSPoint(x: 1.6, y: 13.9), controlPoint2: NSPoint(x: 2.08, y: 13.23))
		textPath.curve(to: NSPoint(x: 5.01, y: 10.37), controlPoint1: NSPoint(x: 3.35, y: 11.79), controlPoint2: NSPoint(x: 4.11, y: 11.08))
		textPath.curve(to: NSPoint(x: 8.05, y: 8.41), controlPoint1: NSPoint(x: 5.91, y: 9.66), controlPoint2: NSPoint(x: 6.93, y: 9.01))
		textPath.curve(to: NSPoint(x: 11.74, y: 6.98), controlPoint1: NSPoint(x: 9.18, y: 7.82), controlPoint2: NSPoint(x: 10.41, y: 7.34))
		textPath.curve(to: NSPoint(x: 15.96, y: 6.44), controlPoint1: NSPoint(x: 13.06, y: 6.62), controlPoint2: NSPoint(x: 14.47, y: 6.44))
		textPath.close()
		textPath.move(to: NSPoint(x: 15.96, y: 8.4))
		textPath.curve(to: NSPoint(x: 12.51, y: 8.84), controlPoint1: NSPoint(x: 14.76, y: 8.4), controlPoint2: NSPoint(x: 13.61, y: 8.54))
		textPath.curve(to: NSPoint(x: 9.41, y: 10.02), controlPoint1: NSPoint(x: 11.41, y: 9.14), controlPoint2: NSPoint(x: 10.37, y: 9.53))
		textPath.curve(to: NSPoint(x: 6.79, y: 11.61), controlPoint1: NSPoint(x: 8.44, y: 10.5), controlPoint2: NSPoint(x: 7.57, y: 11.03))
		textPath.curve(to: NSPoint(x: 4.76, y: 13.33), controlPoint1: NSPoint(x: 6, y: 12.19), controlPoint2: NSPoint(x: 5.33, y: 12.76))
		textPath.curve(to: NSPoint(x: 3.46, y: 14.9), controlPoint1: NSPoint(x: 4.2, y: 13.9), controlPoint2: NSPoint(x: 3.77, y: 14.43))
		textPath.curve(to: NSPoint(x: 3.01, y: 15.99), controlPoint1: NSPoint(x: 3.16, y: 15.37), controlPoint2: NSPoint(x: 3.01, y: 15.73))
		textPath.curve(to: NSPoint(x: 3.46, y: 16.99), controlPoint1: NSPoint(x: 3.01, y: 16.21), controlPoint2: NSPoint(x: 3.16, y: 16.54))
		textPath.curve(to: NSPoint(x: 4.76, y: 18.54), controlPoint1: NSPoint(x: 3.77, y: 17.45), controlPoint2: NSPoint(x: 4.2, y: 17.96))
		textPath.curve(to: NSPoint(x: 6.79, y: 20.28), controlPoint1: NSPoint(x: 5.33, y: 19.11), controlPoint2: NSPoint(x: 6, y: 19.69))
		textPath.curve(to: NSPoint(x: 9.41, y: 21.92), controlPoint1: NSPoint(x: 7.57, y: 20.87), controlPoint2: NSPoint(x: 8.44, y: 21.41))
		textPath.curve(to: NSPoint(x: 12.51, y: 23.13), controlPoint1: NSPoint(x: 10.37, y: 22.42), controlPoint2: NSPoint(x: 11.41, y: 22.82))
		textPath.curve(to: NSPoint(x: 15.96, y: 23.58), controlPoint1: NSPoint(x: 13.61, y: 23.43), controlPoint2: NSPoint(x: 14.76, y: 23.58))
		textPath.curve(to: NSPoint(x: 19.4, y: 23.13), controlPoint1: NSPoint(x: 17.15, y: 23.58), controlPoint2: NSPoint(x: 18.3, y: 23.43))
		textPath.curve(to: NSPoint(x: 22.49, y: 21.92), controlPoint1: NSPoint(x: 20.5, y: 22.82), controlPoint2: NSPoint(x: 21.53, y: 22.42))
		textPath.curve(to: NSPoint(x: 25.11, y: 20.28), controlPoint1: NSPoint(x: 23.45, y: 21.41), controlPoint2: NSPoint(x: 24.32, y: 20.87))
		textPath.curve(to: NSPoint(x: 27.13, y: 18.54), controlPoint1: NSPoint(x: 25.89, y: 19.69), controlPoint2: NSPoint(x: 26.57, y: 19.11))
		textPath.curve(to: NSPoint(x: 28.43, y: 16.99), controlPoint1: NSPoint(x: 27.69, y: 17.96), controlPoint2: NSPoint(x: 28.13, y: 17.45))
		textPath.curve(to: NSPoint(x: 28.89, y: 15.99), controlPoint1: NSPoint(x: 28.74, y: 16.54), controlPoint2: NSPoint(x: 28.89, y: 16.21))
		textPath.curve(to: NSPoint(x: 28.43, y: 14.9), controlPoint1: NSPoint(x: 28.89, y: 15.73), controlPoint2: NSPoint(x: 28.74, y: 15.37))
		textPath.curve(to: NSPoint(x: 27.13, y: 13.33), controlPoint1: NSPoint(x: 28.13, y: 14.43), controlPoint2: NSPoint(x: 27.69, y: 13.9))
		textPath.curve(to: NSPoint(x: 25.11, y: 11.61), controlPoint1: NSPoint(x: 26.57, y: 12.76), controlPoint2: NSPoint(x: 25.89, y: 12.19))
		textPath.curve(to: NSPoint(x: 22.49, y: 10.02), controlPoint1: NSPoint(x: 24.32, y: 11.03), controlPoint2: NSPoint(x: 23.45, y: 10.5))
		textPath.curve(to: NSPoint(x: 19.4, y: 8.84), controlPoint1: NSPoint(x: 21.53, y: 9.53), controlPoint2: NSPoint(x: 20.5, y: 9.14))
		textPath.curve(to: NSPoint(x: 15.96, y: 8.4), controlPoint1: NSPoint(x: 18.3, y: 8.54), controlPoint2: NSPoint(x: 17.15, y: 8.4))
		textPath.close()
		textPath.move(to: NSPoint(x: 15.96, y: 9.9))
		textPath.curve(to: NSPoint(x: 18.33, y: 10.39), controlPoint1: NSPoint(x: 16.8, y: 9.9), controlPoint2: NSPoint(x: 17.59, y: 10.07))
		textPath.curve(to: NSPoint(x: 20.28, y: 11.71), controlPoint1: NSPoint(x: 19.07, y: 10.71), controlPoint2: NSPoint(x: 19.72, y: 11.15))
		textPath.curve(to: NSPoint(x: 21.58, y: 13.65), controlPoint1: NSPoint(x: 20.83, y: 12.27), controlPoint2: NSPoint(x: 21.27, y: 12.91))
		textPath.curve(to: NSPoint(x: 22.05, y: 15.99), controlPoint1: NSPoint(x: 21.9, y: 14.38), controlPoint2: NSPoint(x: 22.05, y: 15.16))
		textPath.curve(to: NSPoint(x: 21.23, y: 19.07), controlPoint1: NSPoint(x: 22.05, y: 17.12), controlPoint2: NSPoint(x: 21.78, y: 18.15))
		textPath.curve(to: NSPoint(x: 19.03, y: 21.25), controlPoint1: NSPoint(x: 20.69, y: 19.98), controlPoint2: NSPoint(x: 19.95, y: 20.71))
		textPath.curve(to: NSPoint(x: 15.96, y: 22.06), controlPoint1: NSPoint(x: 18.11, y: 21.79), controlPoint2: NSPoint(x: 17.08, y: 22.06))
		textPath.curve(to: NSPoint(x: 12.87, y: 21.25), controlPoint1: NSPoint(x: 14.83, y: 22.06), controlPoint2: NSPoint(x: 13.8, y: 21.79))
		textPath.curve(to: NSPoint(x: 10.66, y: 19.07), controlPoint1: NSPoint(x: 11.94, y: 20.71), controlPoint2: NSPoint(x: 11.21, y: 19.98))
		textPath.curve(to: NSPoint(x: 9.85, y: 15.99), controlPoint1: NSPoint(x: 10.11, y: 18.15), controlPoint2: NSPoint(x: 9.84, y: 17.12))
		textPath.curve(to: NSPoint(x: 10.68, y: 12.95), controlPoint1: NSPoint(x: 9.86, y: 14.89), controlPoint2: NSPoint(x: 10.13, y: 13.88))
		textPath.curve(to: NSPoint(x: 12.88, y: 10.74), controlPoint1: NSPoint(x: 11.22, y: 12.03), controlPoint2: NSPoint(x: 11.95, y: 11.29))
		textPath.curve(to: NSPoint(x: 15.96, y: 9.9), controlPoint1: NSPoint(x: 13.8, y: 10.18), controlPoint2: NSPoint(x: 14.83, y: 9.9))
		textPath.close()
		return textPath
	}()

}

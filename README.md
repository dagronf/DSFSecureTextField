# DSFSecureTextField

NSSecureTextField with a 'visibility' button.

![](https://img.shields.io/github/v/tag/dagronf/DSFSecureTextField) ![](https://img.shields.io/badge/macOS-10.10+-red) ![](https://img.shields.io/badge/Swift-5.0-orange.svg)
![](https://img.shields.io/badge/License-MIT-lightgrey) [![](https://img.shields.io/badge/pod-compatible-informational)](https://cocoapods.org) [![](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)


## Why

Sometimes it's nice to be able to see the contents of a password field. `DSFSecureTextField` adds a visibility button to the existing `NSSecureTextField` allowing your users to show or hide the contents of the field.

![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSecureTextField/DSFSecureTextField.gif)

## Integrate

* Copy the file `DSFSecureTextField.swift` into your project
* Or, use CocoaPods
	`pod 'DSFSecureTextField', :git => 'https://github.com/dagronf/DSFSecureTextField/'`
* Or, use Swift Package Manager

## Usage

### Interface builder

1. Drag a Secure Text Field into the canvas
2. Set the `Custom Class` field for the control to `DSFSecureTextField`
3. Done!

### Code

Since `DSFSecureTextField` inherits from `NSSecureTextField`, you can create it exactly as you would for an `NSSecureTextField`

### Demo

There is a very simple project in the `Demos` folder.

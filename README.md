# DSFSecureTextField

NSSecureTextField with a 'visibility' button.

![](https://img.shields.io/github/v/tag/dagronf/DSFSecureTextField) ![](https://img.shields.io/badge/macOS-10.10+-red) ![](https://img.shields.io/badge/Swift-5.0-orange.svg)
![](https://img.shields.io/badge/License-MIT-lightgrey) [![](https://img.shields.io/badge/pod-compatible-informational)](https://cocoapods.org) [![](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

## Why

Sometimes it's nice to be able to see the contents of a password field. `DSFSecureTextField` adds a visibility button to the existing `NSSecureTextField` allowing your users to show or hide the contents of the field.

Optionally, you can choose to dynamically remove the button from the control (for example, if you want to be able to let your users choose whether to show the password or not via a preference)

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

## Configuration

### `allowShowPassword`  ![](https://img.shields.io/badge/Available-InterfaceBuilder-green) ![](https://img.shields.io/badge/Available-Code-blue)

Set to `true` to _allow_ the control to show the password in plain text.  Useful if you want to be able to control whether the user can choose (eg. via preferences) to make the password visible.

### `displayToggleButton`  ![](https://img.shields.io/badge/Available-InterfaceBuilder-green) ![](https://img.shields.io/badge/Available-Code-blue)

When true, displays an 'eye' button embedded within the password field that allows the user to toggle the visibility of the password.
If false, the application needs to provide its own mechanism for setting `passwordIsVisible`. 

### `passwordIsVisible`  ![](https://img.shields.io/badge/Available-Code-blue)

When true, the password is displayed as plain text.
When false, the password is obscured.

## License

```
MIT License

Copyright (c) 2020 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

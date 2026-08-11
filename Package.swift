// swift-tools-version: 5.6

import PackageDescription

let package = Package(
	name: "DSFSecureTextField",
	platforms: [
		.macOS(.v10_13)
	],
	products: [
		.library(name: "DSFSecureTextField", targets: ["DSFSecureTextField"]),
		.library(name: "DSFSecureTextFieldStatic", type: .static, targets: ["DSFSecureTextField"]),
		.library(name: "DSFSecureTextFieldDynamic", type: .dynamic, targets: ["DSFSecureTextField"]),
	],
	targets: [
		.target(
			name: "DSFSecureTextField",
			dependencies: []
		),
		.testTarget(
			name: "DSFSecureTextFieldTests",
			dependencies: ["DSFSecureTextField"]
		),
	]
)

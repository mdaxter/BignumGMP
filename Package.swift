import PackageDescription

let package = Package(
    name: "Bignum",
    dependencies: [
	.Package(url: "https://github.com/mdaxter/CGMP.git", majorVersion: 1)
    ]
)

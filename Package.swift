import PackageDescription

let package = Package(
    name: "BignumGMP",
    dependencies: [
	.Package(url: "https://github.com/mdaxter/CGMP.git", majorVersion: 1)
    ]
)

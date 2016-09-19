import PackageDescription

let package = Package(
	name: "AuroraServer",
    targets: [
      Target(
        name: "Network",
        dependencies: [
          .Target(name: "Framework")
        ]
      ),
      Target(
        name: "Server",
        dependencies: [
          .Target(name: "Framework"),
          .Target(name: "Network")
        ]
      ),
      Target(
        name: "Framework"
      )
    ],
	dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 28),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 0, minor: 15),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", majorVersion: 0, minor: 7)
    ]
)

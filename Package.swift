// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "swift-snapshot-testing-macros-migrator",
  platforms: [
    .macOS(.v15)
  ],
  products: [
    .executable(
      name: "snapshot-migrate",
      targets: ["SnapshotMigrationCLI"]
    ),
    .library(
      name: "SnapshotMigrationSupport",
      targets: ["SnapshotMigrationSupport"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax", from: "602.0.0"),
    /*
     The library is a *test-only* dependency. The migrator itself never imports it — it rewrites
     source text and renames files, and depends only on swift-syntax. The naming-parity suite,
     though, asserts that the names the migrator emits are the names the library's own generator
     resolves, which is the check that keeps the two from drifting apart. Pinning it here makes
     that coupling explicit and versioned, where sharing one repository left it implicit.
     */
    // TODO: pin to a version once the v3 naming work is tagged. It is on a branch because the
    // parity suite asserts against naming behaviour that no release carries yet — which is the
    // skew this split makes visible rather than hidden.
    .package(url: "https://github.com/adammcarter/swift-snapshot-testing-macros", branch: "snapshot-helpers-wip"),
  ],
  targets: [
    .target(
      name: "SnapshotMigrationSupport",
      dependencies: [
        .product(name: "SwiftParser", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
      ]
    ),

    .executableTarget(
      name: "SnapshotMigrationCLI",
      dependencies: [
        "SnapshotMigrationSupport"
      ]
    ),

    .testTarget(
      name: "MigrationTests",
      dependencies: [
        "SnapshotMigrationSupport",
        .product(name: "SnapshotTestingMacros", package: "swift-snapshot-testing-macros"),
        .product(name: "SwiftParser", package: "swift-syntax"),
      ],
      path: "Tests/MigrationTests"
    ),
  ]
)

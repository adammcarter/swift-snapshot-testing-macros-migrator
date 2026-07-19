# Test fixtures

Copies of a legacy suite and the reference artifacts its legacy runtime produced, taken from
`swift-snapshot-testing-macros` when the migrator was extracted from it.

| File | Origin in the library |
| --- | --- |
| `LegacySnapshotTestMigration.swift.fixture` | `Tests/SnapshotsIntegrationTests/SnapshotTest/LegacySnapshotTestMigration.swift` |
| `__Snapshots__LegacySnapshotTestMigration/` | `Tests/SnapshotsIntegrationTests/SnapshotTest/__Snapshots__/LegacySnapshotTestMigration/` |

They are vendored so this package builds and tests without the library checked out beside it.
The `.fixture` extension keeps the test target from compiling a file full of deprecated macros.

## Drift

Nothing enforces that these stay byte-identical to the library's originals — the parity suite
only asserts the paths it computes exist here, so an upstream edit would not fail a test in this
repository.

That is a deliberate trade rather than an oversight, but it is worth understanding:

- The fixture is a **v2-era input**. It exercises the deprecated `@SnapshotSuite` /
  `@SnapshotTest` shapes, which are frozen — the whole point of the migrator is to move adopters
  off them, so the library has no reason to change these files.
- What the parity suite actually asserts is that the *names the migrator computes* match the
  *names the legacy runtime produced*. That relationship is pinned by the artifacts here; if the
  library changed its legacy naming, the migrator would be wrong for every existing adopter's
  checked-in references regardless of what this fixture said.

If the library ever does revise its legacy fixtures, re-copy both entries from the table above
and re-run the parity suite. A byte-comparison test against the library is not possible from
here: SwiftPM exposes a dependency's sources, not its `Tests/` directory.

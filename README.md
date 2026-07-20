# swift-snapshot-testing-macros-migrator

Migrates adopters of [swift-snapshot-testing-macros](https://github.com/adammcarter/swift-snapshot-testing-macros)
from the deprecated `@SnapshotSuite` / `@SnapshotTest` macros to native Swift Testing plus
`#expectSnapshot(...)`.

It is a one-time tool, which is why it lives here rather than in the library: adopters run it once
and never build it again.

## Usage

```shell
Tools/migrate-snapshot-tests --project-root /path/to/your-repo
Tools/migrate-snapshot-tests --project-root /path/to/your-repo --apply --json-report ./report.json
```

Dry-run is the default. `--apply` writes the migrated files.

**It migrates sources *and* references in the same run.** Rewriting the code without moving the
checked-in reference images leaves every assertion unable to resolve its artifact. The first run
then fails, reporting `No reference was found on disk. Automatically recorded snapshot` and asking
you to re-run — and the re-run passes, because it now compares against the files that failed run
wrote. The green is one re-run away, not immediate, which is precisely what makes it easy to walk
into. Renaming references alongside the source turns that into a reviewable diff instead.

See [MIGRATION.md](MIGRATION.md) for the full mapping, the rollout sequence, and what changes
about your reference images on macOS.

## Relationship to the library

The migrator itself does **not** depend on the library — it rewrites source text and renames
files, and needs only `swift-syntax`.

The library is a **test-only** dependency. The naming-parity suite asserts that the names the
migrator emits are the names the library's own generator resolves, which is what stops the two
drifting apart. Keeping that dependency explicit and versioned is the main benefit of the split;
while both lived in one repository the coupling was real but invisible.

## Development

```shell
swift build
swift test
```

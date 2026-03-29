# SuperDB Builds

Independent builds of the `super` binary from the
[BSD-3-Clause licensed source](https://github.com/chrismo/super).

Brimdata [changed the upstream license](https://github.com/brimdata/super/commit/e2e341f8b2559e640ca1e7f8a0b42078ddfef01c)
from BSD-3-Clause to the
[SuperDB Source Available License v1.0](https://github.com/brimdata/super/blob/9343c50f2cdaf39ecfb3f90a458c552d3d0f8681/LICENSE.md),
a custom source-available license that restricts providing the software as a
database service. This repo builds from a fork pinned to the last open-source
commit.

**Note:** Starting with v0.1.0, official binaries are available directly from
[brimdata/super releases](https://github.com/brimdata/super/releases). The
[asdf-superdb plugin](https://github.com/chrismo/asdf-superdb) now downloads
official release binaries and uses this repo's builds for pre-release versions.

## License

The build scripts in this repo are licensed under the
[BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause).

This repo builds and distributes binaries from a
[fork](https://github.com/chrismo/super) of
[SuperDB](https://github.com/brimdata/super), pinned to the last BSD-3-Clause
licensed commit. The upstream project is now licensed under the
[SuperDB Source Available License](https://github.com/brimdata/super/blob/main/LICENSE.md).

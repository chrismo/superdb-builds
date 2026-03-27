# SuperDB Builds

Independent builds of the `super` binary from the
[BSD-3-Clause licensed source](https://github.com/chrismo/super).

Brimdata [changed the upstream license](https://github.com/brimdata/super/commit/e2e341f8b2559e640ca1e7f8a0b42078ddfef01c)
from BSD-3-Clause to the
[SuperDB Source Available License v1.0](https://github.com/brimdata/super/blob/9343c50f2cdaf39ecfb3f90a458c552d3d0f8681/LICENSE.md),
a custom source-available license that restricts providing the software as a
database service. This repo builds from a fork pinned to the last open-source
commit.

**Note:** Starting with v0.3.0, official binaries are available directly from
[brimdata/super releases](https://github.com/brimdata/super/releases). The
[asdf-superdb plugin](https://github.com/chrismo/asdf-superdb) now downloads
official release binaries for v0.3.0+ and uses this repo's builds for earlier
versions.

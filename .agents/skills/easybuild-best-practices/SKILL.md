---
name: easybuild-best-practices
description: Use when writing or reviewing EasyBuild easyconfig files. Use when selecting toolchains, structuring easyconfig parameters, adding sanity checks, or contributing easyconfigs to the central repository.
metadata:
  author: maiconfaria
  source: https://github.com/maiconfaria/skills
  source-path: .agents/skills/easybuild-best-practices
---

# EasyBuild Best Practices

**Reference:** [EasyBuild documentation](https://docs.easybuild.io)

## Easyconfig Naming Convention

Easyconfig files follow a strict naming scheme:

```
<name>-<version>[-<toolchain>][<versionsuffix>].eb
```

- `<toolchain>` is omitted when using the `SYSTEM` toolchain
- `<versionsuffix>` is omitted when empty

Examples:
- `HPL-2.3-foss-2025b.eb`
- `bzip2-1.0.8-GCCcore-12.3.0.eb`
- `Python-3.10.8-GCCcore-12.2.0-bare.eb`

The filename is critical for dependency resolution (`--robot`).

## Mandatory Parameters

Every easyconfig must include:

| Parameter | Purpose |
|-----------|---------|
| `name` | Software name |
| `version` | Software version |
| `homepage` | Project URL |
| `description` | Short description (used for module help) |
| `toolchain` | Dict with `name` and `version`, e.g. `{'name': 'foss', 'version': '2025b'}` |

Example:

```python
name = 'HPL'
version = '2.3'
homepage = 'http://www.netlib.org/benchmark/hpl/'
description = "High Performance Computing Linpack Benchmark"
toolchain = {'name': 'foss', 'version': '2025b'}
```

Planned future requirements: `docurls`, `software_license`, `software_license_urls`.

## Toolchain Selection

Use **common toolchains** (`foss` or `intel`) for broad compatibility across HPC sites.

### Supported Generations

As of EasyBuild 5.3.0 (April 2026):

| Generation | Status | GCC |
|------------|--------|-----|
| 2026.1 | active | 15.2.0 |
| 2025b | active | 14.3.0 |
| 2025a | active | 14.2.0 |
| 2024a | active | 13.3.0 |
| 2023b | active | 13.2.0 |
| 2023a | active | 12.3.0 |
| 2022b | deprecated | 12.2.0 |
| 2022a | deprecated | 11.3.0 |
| 2021b and older | archived | — |

### Toolchain Layers

Each layer adds capabilities. Match the **highest** level your dependencies use:

```
GCCcore -> GCC -> gompi -> foss
```

- **GCCcore**: compiler, binutils
- **GCC**: full GCC suite
- **gompi**: GCC + OpenMPI
- **foss**: gompi + FlexiBLAS (OpenBLAS/LAPACK) + ScaLAPACK + FFTW

### Key Principles

- **Use the exact software versions bundled in the toolchain.** Do not override toolchain components or pin custom versions.
- **Reuse existing easyconfigs from the central repository** whenever possible.
- **Always ask before creating new recipes** — do not write a new easyconfig without explicit confirmation.
- **Use EasyBuild hooks for site-specific customizations** instead of modifying easyconfigs. See [Customizing EasyBuild via hooks](https://docs.easybuild.io/en/stable/hooks/). Hooks let you inject logic at build steps without forking recipes.
- Use `SYSTEM` toolchain only for tools that do not depend on any compiler (e.g. pure Python packages that provide a `pip install` command).

## Easyconfig Parameter Order

Follow the central repository convention for parameter ordering:

```python
name
version
homepage
description
toolchain
source_urls
sources
patches
checksums
dependencies
buildopts
installopts
sanity_check_paths
moduleclass
```

Use `eb --inject-checksums` to automatically compute and inject SHA256 checksums rather than typing them manually:

```bash
eb bzip2-1.0.6.eb --inject-checksums
```

## Sources & Checksums

- **Always provide SHA256 checksums** for all source files and patches
- Use `%(version)s` templates instead of hardcoded version strings:

```python
source_urls = ['http://www.bzip.org/%(version)s/']
sources = ['bzip2-%(version)s.tar.gz']
checksums = ['a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd']
```

- For Git-based sources, use the `git_config` dict format:

```python
sources = [{
    'git_config': {
        'url': 'https://github.com/example/repo.git',
        'tag': 'v%(version)s',
    }
}]
```

## Sanity Checks

**Always** specify `sanity_check_paths` to verify the installation produced the expected files (binaries, libraries, headers):

```python
sanity_check_paths = {
    'files': ['bin/hpl'],
    'dirs': [],
}
```

Optionally add `sanity_check_commands` for runtime verification:

```python
sanity_check_commands = ['hpl --help']
```

## Dependencies

- Pin exact dependency versions that match the toolchain generation
- Let `--robot` resolve the full dependency graph automatically
- Use `external_modules` for site-provided software that should not be built by EasyBuild

## Module Class

Set `moduleclass` to control module directory organization. Recommended values:

`tools`, `lib`, `devel`, `bio`, `chem`, `phys`, `data`, `cae`, `vis`, `perf`, `compiler`, `mpi`, `math`, `system`, `base`

## Verification Commands

```bash
# Show every configuration setting and its source
eb --show-full-config

# Show only non-default configuration settings
eb --show-config

# Validate easyconfig style before submitting a PR
eb --check-style my-software-1.0-foss-2025b.eb

# Dry-run with dependency resolution to preview what will be built
eb my-software-1.0-foss-2025b.eb -Dr

# Verify the installed version
eb --version
```

## Contributing to Central Repo

- **Target only the 6 most recent toolchain generations.** PRs for older generations are rejected.
- Deprecated (7-8 generations old) and archived (9+) easyconfigs are not accepted.
- Run `eb --check-style` before submitting — style violations block PRs.
- Provide a test report using `eb --output-format json` to document build results.
- Use `eb --inject-checksums --robot` on the full dependency chain before submitting.

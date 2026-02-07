# Contributing to RobotLibrary

> [!WARNING]
> This project is primarily developed with the assistance of AI coding agents.
> Contributions, issues, and pull requests are welcome, but please be aware that
> large portions of the codebase — including tests, documentation, and CI
> configuration — have been authored or co-authored by AI.

## Development Setup

### Prerequisites

- Python 3.9 or later
- [Robot Framework](https://robotframework.org/) 5.0+
- GNU Make

### Getting Started

```bash
# Clone the repository
git clone https://github.com/datakurre/robotframework-robotlibrary.git
cd robotframework-robotlibrary

# Install in editable mode
make install

# Run the tests
make test
```

### Alternative: Nix/devenv

If you use [devenv](https://devenv.sh/), the repository includes a
`devenv.nix` that sets up Python, ruff, build tools, and git hooks
automatically:

```bash
devenv shell
```

## Development Workflow

This project follows a **feature-branch workflow**:

1. Fork the repository and create a feature branch from `main`.
2. Make your changes in small, focused commits.
3. Ensure all checks pass locally before pushing.
4. Open a pull request against `main`.

### Makefile Targets

| Target         | Description                                  |
| -------------- | -------------------------------------------- |
| `make install` | Install the package in editable mode         |
| `make test`    | Run the Robot Framework acceptance tests     |
| `make lint`    | Run ruff linter and format checker           |
| `make format`  | Auto-fix lint issues and format code         |
| `make build`   | Build sdist and wheel into `dist/`           |
| `make check`   | Build and verify the distribution with twine |
| `make libdoc`  | Generate keyword documentation HTML          |
| `make clean`   | Remove all build and output artifacts        |

### Before Submitting a PR

```bash
make lint      # check for lint / formatting issues
make test      # run the full acceptance test suite
```

Both checks run automatically in CI on every pull request.

## Testing

RobotLibrary uses **meta-testing**: Robot Framework tests that exercise other
Robot Framework test files. The test structure is:

- `tests/test_*.robot` — meta-tests that verify RobotLibrary's behaviour
- `tests/examples/` — target `.robot` files used as injection targets

When adding a new feature, add both:

1. An example `.robot` file in `tests/examples/` that demonstrates the
   target pattern.
2. A meta-test in `tests/` that uses `Run Robot Test` to exercise it.

## Releases

Releases are automated via GitHub Actions:

1. Update the version in `src/RobotLibrary/_version.py`.
2. Commit, tag with `v<version>` (e.g. `v0.2.0`), and push the tag.
3. CI runs the full test matrix; on success the package is built and published
   to PyPI, and a GitHub Release is created automatically.

## Code Style

- Python code is formatted and linted with [Ruff](https://docs.astral.sh/ruff/).
- Robot Framework files follow standard Robot Framework style conventions.

## License

By contributing you agree that your contributions will be licensed under the
[Apache License 2.0](LICENSE).

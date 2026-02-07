# RobotLibrary

> [!WARNING]
> This project is primarily developed with the assistance of AI coding agents.
> See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

A [Robot Framework](https://robotframework.org/) library for testing Robot
Framework tests and tasks *within* Robot Framework itself — without subprocess
execution.

## Overview

RobotLibrary enables meta-testing: you write Robot Framework tests that
exercise *other* `.robot` test/task files. The target suite's steps are
injected into the calling test at runtime using the Listener v3 API, so
everything runs in a single process with clean logs.

**Key features:**

- **No subprocess execution** — tests run in the same Python process.
- **Control structures** — FOR, IF, WHILE, TRY/EXCEPT, BREAK, CONTINUE all work.
- **Test setup/teardown** — `[Setup]` and `[Teardown]` from target tests are injected.
- **Suite-level fixtures** — default `Test Setup` / `Test Teardown` from target `*** Settings ***` are honoured.
- **Resource imports** — resource files imported by the target suite are auto-imported at runtime.
- **Variable override** — suite variables (scalar, list, and dict) can be overridden per test.
- **Clean logs** — injected steps appear directly in the test body.
- **Works with both tests and tasks.**

**Important limitations:**

- **Early development** — many Robot Framework edge cases are not yet handled.
- **No library imports** — only Resource imports from the target suite are handled; Library imports are not.
- **No suite setup/teardown** — `Suite Setup` / `Suite Teardown` from target files are ignored (only test-level fixtures are injected).
- **Setup/teardown semantics** — target `[Setup]` and `[Teardown]` are injected as regular body steps, so they lack the special RF semantics (e.g. teardown always running on failure).
- **Advanced variable scoping** — complex variable expressions or scoping beyond `Set Test Variable` may not work.

## Installation

```bash
pip install robotframework-robotlibrary
```

Or install from source for development:

```bash
pip install -e .
```

## Quick Start

Given a target test suite (`login.robot`):

```robotframework
*** Variables ***
${USERNAME}    default_user
${PASSWORD}    default_pass

*** Test Cases ***
Login Test
    Log    Logging in as ${USERNAME}
    Should Not Be Empty    ${USERNAME}
    Should Not Be Empty    ${PASSWORD}
```

Write a meta-test suite (`test_login.robot`):

```robotframework
*** Settings ***
Library    RobotLibrary

*** Test Cases ***
Test Login With Defaults
    Run Robot Test    ${CURDIR}/login.robot    Login Test

Test Login With Custom Credentials
    Run Robot Test    ${CURDIR}/login.robot    Login Test
    ...    USERNAME=admin
    ...    PASSWORD=secret
```

Run the meta-tests:

```bash
robot test_login.robot
```

## Keyword Documentation

### Run Robot Test

```
Run Robot Test    suite_path    test_name    **variables
```

| Argument       | Description                                                         |
| -------------- | ------------------------------------------------------------------- |
| `suite_path`   | Path to the `.robot` file (absolute, or relative to current suite). |
| `test_name`    | Name of the test case or task to run.                               |
| `**variables`  | Variable overrides as `NAME=value` pairs.                           |

The keyword also works with `Test Template` for data-driven testing:

```robotframework
*** Settings ***
Library          RobotLibrary
Test Template    Run task

*** Keywords ***
Run task
    [Arguments]    ${NAME}
    Run Robot Test    ${CURDIR}/tasks.robot    Log name    NAME=${NAME}

*** Test Cases ***    NAME
Log John              John
Log Jane              Jane
```

### Run Robot Task

```
Run Robot Task    suite_path    task_name    **variables
```

An alias for `Run Robot Test` designed for RPA task suites (files using
`*** Tasks ***` instead of `*** Test Cases ***`). It works identically —
the target task's steps are injected into the calling test or task at runtime.

| Argument       | Description                                                              |
| -------------- | ------------------------------------------------------------------------ |
| `suite_path`   | Path to the `.robot` file containing tasks.                              |
| `task_name`    | Name of the task to run.                                                 |
| `**variables`  | Variable overrides as `NAME=value` pairs.                                |

```robotframework
*** Settings ***
Library    RobotLibrary

*** Test Cases ***
Test Invoice Processing
    Run Robot Task    ${CURDIR}/process.robot    Process Invoice
    ...    SOURCE=invoices.csv
```

The keyword also works with `Task Template` in task suites:

```robotframework
*** Settings ***
Library          RobotLibrary
Task Template    Run Robot Task

*** Tasks ***                  SUITE_PATH                    TASK_NAME      NAME
Process John                   ${CURDIR}/tasks.robot         Log name       John
Process Jane                   ${CURDIR}/tasks.robot         Log name       Jane
```

## How It Works

1. `Run Robot Test` (or `Run Robot Task`) acts as a *marker* keyword (it does nothing by itself).
2. The library registers itself as a Listener v3 via `@library(listener='SELF')`.
3. In the `start_test` hook (which fires for both tests *and* tasks), the listener finds all `Run Robot Test` / `Run Robot Task` markers.
4. The target `.robot` file is parsed (and cached) using `TestSuite.from_file_system()`.
5. Resource files imported by the target suite are loaded via `Import Resource`.
6. Variables from the target suite's `*** Variables ***` section (scalar, list,
   and dict) are injected as `Set Test Variable` calls.
7. `[Setup]` and `[Teardown]` from the target test/task are injected as regular body
   steps (first and last, respectively).
8. Test/task body steps (including all control structures) are deep-copied and inserted.
9. The marker keyword is removed — logs show only the injected steps.

**Task support:** Target suites can use either `*** Test Cases ***` or
`*** Tasks ***`.  The Robot Framework model treats both uniformly, so all
features (variable injection, control structures, setup/teardown,
`Task Setup`/`Task Teardown` from the Settings section) work transparently.

**Note:** This is a proof-of-concept implementation. The step injection mechanism
has been tested with control structures (FOR, WHILE, IF, TRY/EXCEPT, BREAK,
CONTINUE), setup/teardown, resource imports, and complex variable types, but has
not been tested with custom libraries with state, nested suite hierarchies, or
advanced variable scoping.

## Development

```bash
# Install in editable mode
pip install -e .

# Run acceptance tests (meta-tests)
make test

# Generate keyword documentation
make libdoc

# Clean build artifacts
make clean
```

### Test Organization

The repository includes comprehensive meta-tests that verify RobotLibrary's
injection mechanism:

- **`tests/`** — Meta-tests that test RobotLibrary itself
- **`tests/examples/`** — Example test suites that serve as injection targets

See [tests/README.md](tests/README.md) and
[tests/examples/README.md](tests/examples/README.md) for details on the test
organization and examples of testable test patterns.

## License

Apache License 2.0 — see [LICENSE](LICENSE) for details.

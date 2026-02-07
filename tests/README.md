# Meta-Test Suite

This directory contains **meta-tests** that test RobotLibrary itself by
injecting and running the example test suites from `examples/`.

## Meta-Test Organization

| File | Feature Tested | Example Used |
|------|----------------|--------------|
| **test_basic_injection.robot** | Basic injection with FOR/IF, variable overrides | `login_example.robot` |
| **test_control_structures.robot** | WHILE, TRY/EXCEPT, BREAK, CONTINUE | `control_structures_example.robot` |
| **test_fixtures.robot** | Test [Setup] and [Teardown] | `setup_teardown_example.robot` |
| **test_suite_level_fixtures.robot** | Suite-level Test Setup/Teardown | `suite_fixtures_example.robot` |
| **test_resource_imports.robot** | Resource file imports | `resource_imports_example.robot` |
| **test_variables.robot** | Scalar, list, and dict variables | `variables_example.robot` |
| **test_task_injection.robot** | Task injection (vs test injection) | `simple_task.robot` |
| **test_template_injection.robot** | Data-driven testing with Test Template | `simple_task.robot` |

## Running Meta-Tests

Run all meta-tests from the repository root:

```bash
make test
```

Or run individual test suites:

```bash
python3 -m robot --outputdir output tests/test_basic_injection.robot
python3 -m robot --outputdir output tests/test_control_structures.robot
```

## Test Structure

Each meta-test follows a clear pattern:

1. **Import RobotLibrary** in *** Settings ***
2. **Call `Run Robot Test`** to inject an example suite
3. **Verify the expected behavior** through assertions in the example suite

Example:

```robotframework
*** Settings ***
Library    RobotLibrary

*** Test Cases ***
Test WHILE Loop Injection
    [Documentation]    Verify WHILE loops work when injected.
    Run Robot Test    ${CURDIR}/examples/control_structures_example.robot
    ...               Test With WHILE Loop
```

The meta-test passes if the injected example test executes successfully with
all its assertions passing.

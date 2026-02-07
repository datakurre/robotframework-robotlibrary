# Example Test Suites

This directory contains example Robot Framework test suites that can be
**injected** by RobotLibrary for meta-testing. Each example demonstrates
different Robot Framework features that work with RobotLibrary's injection
mechanism.

## Example Suites

| File | Description |
|------|-------------|
| **login_example.robot** | Basic test suite with variables, FOR loops, and IF structures |
| **simple_task.robot** | Example task suite (demonstrates tasks vs tests) |
| **control_structures_example.robot** | Advanced control structures: WHILE, TRY/EXCEPT, BREAK, CONTINUE |
| **setup_teardown_example.robot** | Test-level [Setup] and [Teardown] |
| **suite_fixtures_example.robot** | Suite-level Test Setup/Teardown from *** Settings *** |
| **resource_imports_example.robot** | Resource file imports |
| **variables_example.robot** | Scalar, list, and dict variables |
| **keywords.resource** | Resource file with reusable keywords |

## Usage

These example suites are used by the meta-tests in the parent `tests/`
directory. For instance:

```robotframework
*** Settings ***
Library    RobotLibrary

*** Test Cases ***
Test Simple Login
    Run Robot Test    ${CURDIR}/examples/login_example.robot    Simple Test

Test With Custom Variables
    Run Robot Test    ${CURDIR}/examples/login_example.robot    Simple Test
    ...    USERNAME=admin
    ...    PASSWORD=secret123
```

## Real-World Use Cases

These examples also serve as templates for creating your own testable tests:

- **Regression testing** — inject parameterized test suites with different configurations
- **Test validation** — verify that test suites work correctly before deployment
- **Test generation** — dynamically compose tests from reusable test fragments
- **Behavior verification** — ensure test behavior matches specifications

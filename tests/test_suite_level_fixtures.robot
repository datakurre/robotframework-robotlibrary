*** Settings ***
Documentation    Meta-tests for suite-level Test Setup/Teardown from *** Settings ***.
Library          RobotLibrary

*** Test Cases ***
Test Default Test Setup From Settings
    [Documentation]    Verify that default Test Setup from the target suite's Settings is injected.
    Run Robot Test    ${CURDIR}/examples/suite_fixtures_example.robot    Test Using Default Setup

Test Override Setup From Settings
    [Documentation]    Verify that a test overriding the default setup works.
    Run Robot Test    ${CURDIR}/examples/suite_fixtures_example.robot    Test Overriding Setup

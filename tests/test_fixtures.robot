*** Settings ***
Documentation    Meta-tests for test-level [Setup] and [Teardown] injection.
Library          RobotLibrary

*** Test Cases ***
Test Setup Injection
    [Documentation]    Verify that [Setup] from the target test is injected.
    Run Robot Test    ${CURDIR}/examples/setup_teardown_example.robot    Test With Setup

Test Teardown Injection
    [Documentation]    Verify that [Teardown] from the target test is injected.
    Run Robot Test    ${CURDIR}/examples/setup_teardown_example.robot    Test With Teardown

Test Setup And Teardown Injection
    [Documentation]    Verify both [Setup] and [Teardown] are injected.
    Run Robot Test    ${CURDIR}/examples/setup_teardown_example.robot    Test With Setup And Teardown

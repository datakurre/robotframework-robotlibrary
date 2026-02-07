*** Settings ***
Documentation    Example suite demonstrating test-level [Setup] and [Teardown].
...              Shows how RobotLibrary injects test setup and teardown steps.

*** Variables ***
${SETUP_FLAG}      not_set
${TEARDOWN_FLAG}   not_set

*** Test Cases ***
Test With Setup
    [Documentation]    Test that has a [Setup].
    [Setup]    Set Test Variable    ${SETUP_FLAG}    setup_done
    Should Be Equal    ${SETUP_FLAG}    setup_done
    Log    Test body after setup

Test With Teardown
    [Documentation]    Test that has a [Teardown].
    Log    Test body before teardown
    [Teardown]    Log    Teardown executed

Test With Setup And Teardown
    [Documentation]    Test that has both [Setup] and [Teardown].
    [Setup]    Set Test Variable    ${SETUP_FLAG}    setup_done
    Should Be Equal    ${SETUP_FLAG}    setup_done
    Log    Test body
    [Teardown]    Log    Teardown executed

*** Settings ***
Documentation    Example suite with suite-level and test-level fixtures.
...              Demonstrates default Test Setup/Teardown from *** Settings ***.
Suite Setup      Log    Suite setup executed
Suite Teardown   Log    Suite teardown executed
Test Setup       Set Test Variable    ${DEFAULT_SETUP}    from_test_setup
Test Teardown    Log    Default test teardown executed

*** Variables ***
${DEFAULT_SETUP}    not_set

*** Test Cases ***
Test Using Default Setup
    [Documentation]    Test relying on default Test Setup from Settings.
    Should Be Equal    ${DEFAULT_SETUP}    from_test_setup
    Log    Test body executed

Test Overriding Setup
    [Documentation]    Test overriding the default Test Setup.
    [Setup]    Set Test Variable    ${DEFAULT_SETUP}    from_override
    Should Be Equal    ${DEFAULT_SETUP}    from_override

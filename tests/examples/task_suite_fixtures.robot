*** Settings ***
Documentation    Example RPA task suite with suite-level Task Setup and Task Teardown.
...              Demonstrates that Task Setup/Task Teardown from *** Settings *** are
...              handled the same way as Test Setup/Test Teardown.
Task Setup       Set Test Variable    ${DEFAULT_TASK_SETUP}    from_task_setup
Task Teardown    Log    Default task teardown executed

*** Variables ***
${DEFAULT_TASK_SETUP}    not_set

*** Tasks ***
Task Using Default Setup
    [Documentation]    Task relying on default Task Setup from Settings.
    Should Be Equal    ${DEFAULT_TASK_SETUP}    from_task_setup
    Log    Task body executed

Task Overriding Setup
    [Documentation]    Task overriding the default Task Setup.
    [Setup]    Set Test Variable    ${DEFAULT_TASK_SETUP}    from_override
    Should Be Equal    ${DEFAULT_TASK_SETUP}    from_override

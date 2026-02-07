*** Settings ***
Documentation    Example RPA task suite with task-level [Setup] and [Teardown].
...              Demonstrates that RobotLibrary handles task fixtures correctly.

*** Variables ***
${TASK_FLAG}    not_set

*** Tasks ***
Task With Setup
    [Documentation]    Task that has a [Setup].
    [Setup]    Set Test Variable    ${TASK_FLAG}    setup_done
    Should Be Equal    ${TASK_FLAG}    setup_done
    Log    Task body after setup

Task With Teardown
    [Documentation]    Task that has a [Teardown].
    Log    Task body before teardown
    [Teardown]    Log    Task teardown executed

Task With Setup And Teardown
    [Documentation]    Task with both [Setup] and [Teardown].
    [Setup]    Set Test Variable    ${TASK_FLAG}    setup_done
    Should Be Equal    ${TASK_FLAG}    setup_done
    Log    Task body
    [Teardown]    Log    Task teardown executed

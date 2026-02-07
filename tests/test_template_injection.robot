*** Settings ***
Documentation    Meta-tests for data-driven testing with Test Template.
...              Tests both Run Robot Test and Run Robot Task with templates.
Library          RobotLibrary
Test Template    Run task

*** Keywords ***
Run task
    [Arguments]    ${NAME}
    Run Robot Task    ${CURDIR}/examples/simple_task.robot    Log name    NAME=${NAME}

*** Test Cases ***    NAME
Log John              John
Log Jane              Jane

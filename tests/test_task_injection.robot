*** Settings ***
Documentation    Meta-tests for task injection (*** Tasks *** suites).
...              Verifies that RobotLibrary works with both Run Robot Test and
...              Run Robot Task when the target suite uses *** Tasks ***.
Library          RobotLibrary

*** Test Cases ***
Test Task Injection With Run Robot Test
    [Documentation]    Run a task from a task suite using Run Robot Test.
    Run Robot Test    ${CURDIR}/examples/simple_task.robot    Log name    NAME=John

Test Task Injection With Run Robot Task
    [Documentation]    Run a task from a task suite using the Run Robot Task alias.
    Run Robot Task    ${CURDIR}/examples/simple_task.robot    Log name    NAME=Jane

Test Task With FOR Loop
    [Documentation]    Verify FOR loops work when injecting from a task suite.
    Run Robot Task    ${CURDIR}/examples/task_with_logic.robot    Task With FOR Loop

Test Task With FOR Loop Custom Variable
    [Documentation]    Verify variable overrides work with task suites.
    Run Robot Task    ${CURDIR}/examples/task_with_logic.robot    Task With FOR Loop
    ...    QUANTITY=2

Test Task With IF Structure
    [Documentation]    Verify IF/ELSE works when injecting from a task suite.
    Run Robot Task    ${CURDIR}/examples/task_with_logic.robot    Task With IF Structure

Test Task With Setup
    [Documentation]    Verify [Setup] from a target task is injected.
    Run Robot Task    ${CURDIR}/examples/task_with_fixtures.robot    Task With Setup

Test Task With Teardown
    [Documentation]    Verify [Teardown] from a target task is injected.
    Run Robot Task    ${CURDIR}/examples/task_with_fixtures.robot    Task With Teardown

Test Task With Setup And Teardown
    [Documentation]    Verify both [Setup] and [Teardown] from a target task are injected.
    Run Robot Task    ${CURDIR}/examples/task_with_fixtures.robot    Task With Setup And Teardown

Test Task Suite Level Fixtures
    [Documentation]    Verify default Task Setup from the target suite's Settings is injected.
    Run Robot Task    ${CURDIR}/examples/task_suite_fixtures.robot    Task Using Default Setup

Test Task Suite Level Fixture Override
    [Documentation]    Verify a task overriding the default Task Setup works.
    Run Robot Task    ${CURDIR}/examples/task_suite_fixtures.robot    Task Overriding Setup

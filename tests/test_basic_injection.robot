*** Settings ***
Documentation    Meta-tests for RobotLibrary — basic test injection with variables, FOR, and IF.
Library          RobotLibrary

*** Test Cases ***
Test Simple Test With Defaults
    [Documentation]    Run the simple test with default variables.
    Run Robot Test    ${CURDIR}/examples/login_example.robot    Simple Test

Test Simple Test With Custom Values
    [Documentation]    Run the simple test with overridden variable values.
    Run Robot Test    ${CURDIR}/examples/login_example.robot    Simple Test
    ...    USERNAME=custom_user
    ...    PASSWORD=secret123

Test FOR Loop Injection
    [Documentation]    Verify FOR loops from the target test work correctly.
    Run Robot Test    ${CURDIR}/examples/login_example.robot    Test With FOR Loop

Test FOR Loop With Custom Counter
    [Documentation]    Test FOR loop with an overridden counter value.
    Run Robot Test    ${CURDIR}/examples/login_example.robot    Test With FOR Loop
    ...    COUNTER=3

Test IF Structure Injection
    [Documentation]    Verify IF/ELSE structures work correctly.
    Run Robot Test    ${CURDIR}/examples/login_example.robot    Test With IF Structure

Test IF Structure With Zero Counter
    [Documentation]    Test IF structure with counter set to zero.
    Run Robot Test    ${CURDIR}/examples/login_example.robot    Test With IF Structure
    ...    COUNTER=0

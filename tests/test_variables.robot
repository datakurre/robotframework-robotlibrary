*** Settings ***
Documentation    Meta-tests for scalar, list, and dict variable injection.
Library          RobotLibrary

*** Test Cases ***
Test List Variable Injection
    [Documentation]    Verify list variables from the target suite are injected.
    Run Robot Test    ${CURDIR}/examples/variables_example.robot    Test With List Variable

Test Dict Variable Injection
    [Documentation]    Verify dict variables from the target suite are injected.
    Run Robot Test    ${CURDIR}/examples/variables_example.robot    Test With Dict Variable

Test Composed Variable Injection
    [Documentation]    Verify composed variable expressions work.
    Run Robot Test    ${CURDIR}/examples/variables_example.robot    Test With Composed Variable

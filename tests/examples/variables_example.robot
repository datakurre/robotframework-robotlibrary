*** Settings ***
Documentation    Example suite demonstrating scalar, list, and dict variables.
...              Shows how RobotLibrary injects different variable types.

*** Variables ***
@{NAMES}         Alice    Bob    Charlie
&{CONFIG}        host=localhost    port=8080
${GREETING}      Hello
${TARGET}        World

*** Test Cases ***
Test With List Variable
    [Documentation]    Test with a list variable.
    Length Should Be    ${NAMES}    3
    Should Be Equal    ${NAMES}[0]    Alice
    Should Be Equal    ${NAMES}[2]    Charlie

Test With Dict Variable
    [Documentation]    Test with a dictionary variable.
    Should Be Equal    ${CONFIG}[host]    localhost
    Should Be Equal    ${CONFIG}[port]    8080

Test With Composed Variable
    [Documentation]    Test with variables composed from other variables.
    ${message}=    Set Variable    ${GREETING}, ${TARGET}!
    Should Be Equal    ${message}    Hello, World!

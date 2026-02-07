*** Settings ***
Documentation    Example test suite demonstrating basic RF features.
...              This suite can be injected by RobotLibrary meta-tests.
...              Tests include simple keyword calls, FOR loops, and IF structures.

*** Variables ***
${USERNAME}      default_user
${PASSWORD}      default_pass
${COUNTER}       5

*** Test Cases ***
Simple Test
    [Documentation]    A simple test with basic keywords.
    Log    Username is ${USERNAME}
    Should Not Be Empty    ${USERNAME}
    Should Not Be Empty    ${PASSWORD}

Test With FOR Loop
    [Documentation]    Test with a FOR loop to demonstrate control structure support.
    Log    Starting loop with counter ${COUNTER}
    FOR    ${i}    IN RANGE    ${COUNTER}
        Log    Iteration ${i}
        Should Be True    ${i} < ${COUNTER}
    END
    Log    Loop completed

Test With IF Structure
    [Documentation]    Test with IF/ELSE to demonstrate conditional logic support.
    IF    ${COUNTER} > 0
        Log    Counter is positive: ${COUNTER}
    ELSE IF    ${COUNTER} == 0
        Log    Counter is zero
    ELSE
        Log    Counter is negative
    END

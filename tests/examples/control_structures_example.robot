*** Settings ***
Documentation    Example suite exercising advanced control structures.
...              This suite demonstrates WHILE loops, TRY/EXCEPT/FINALLY,
...              BREAK and CONTINUE statements that can be injected by RobotLibrary.

*** Variables ***
${LIMIT}    5

*** Test Cases ***
Test With WHILE Loop
    [Documentation]    Test WHILE loop support.
    ${i}=    Set Variable    ${0}
    WHILE    ${i} < ${LIMIT}
        Log    WHILE iteration ${i}
        ${i}=    Evaluate    ${i} + 1
    END
    Should Be Equal As Integers    ${i}    ${LIMIT}

Test With TRY EXCEPT
    [Documentation]    Test TRY/EXCEPT support.
    TRY
        Log    Inside TRY block
        Should Be True    ${TRUE}
    EXCEPT
        Fail    Should not reach EXCEPT
    END
    Log    After TRY/EXCEPT

Test With TRY EXCEPT FINALLY
    [Documentation]    Test TRY/EXCEPT/FINALLY support.
    ${result}=    Set Variable    initial
    TRY
        ${result}=    Set Variable    from_try
    EXCEPT
        ${result}=    Set Variable    from_except
    FINALLY
        Log    In FINALLY block, result=${result}
    END
    Should Be Equal    ${result}    from_try

Test With FOR And BREAK
    [Documentation]    Test BREAK inside a FOR loop.
    ${last}=    Set Variable    ${-1}
    FOR    ${i}    IN RANGE    10
        ${last}=    Set Variable    ${i}
        IF    ${i} == 3
            BREAK
        END
    END
    Should Be Equal As Integers    ${last}    ${3}

Test With FOR And CONTINUE
    [Documentation]    Test CONTINUE inside a FOR loop — skips logging odd numbers.
    ${sum}=    Set Variable    ${0}
    FOR    ${i}    IN RANGE    6
        ${is_odd}=    Evaluate    ${i} % 2 != 0
        IF    ${is_odd}
            CONTINUE
        END
        # Only even numbers reach here: 0, 2, 4 → sum = 6
        ${sum}=    Evaluate    ${sum} + ${i}
    END
    Should Be Equal As Integers    ${sum}    ${6}

Test With WHILE And BREAK
    [Documentation]    Test BREAK inside a WHILE loop.
    ${counter}=    Set Variable    ${0}
    WHILE    ${TRUE}
        ${counter}=    Evaluate    ${counter} + 1
        IF    ${counter} >= 3
            BREAK
        END
    END
    Should Be Equal As Integers    ${counter}    ${3}

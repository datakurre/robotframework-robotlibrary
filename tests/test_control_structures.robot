*** Settings ***
Documentation    Meta-tests for advanced control structures (WHILE, TRY, BREAK, CONTINUE).
Library          RobotLibrary

*** Test Cases ***
Test WHILE Loop Injection
    [Documentation]    Verify WHILE loops from the target test work correctly.
    Run Robot Test    ${CURDIR}/examples/control_structures_example.robot    Test With WHILE Loop

Test TRY EXCEPT Injection
    [Documentation]    Verify TRY/EXCEPT from the target test works correctly.
    Run Robot Test    ${CURDIR}/examples/control_structures_example.robot    Test With TRY EXCEPT

Test TRY EXCEPT FINALLY Injection
    [Documentation]    Verify TRY/EXCEPT/FINALLY works correctly.
    Run Robot Test    ${CURDIR}/examples/control_structures_example.robot    Test With TRY EXCEPT FINALLY

Test FOR With BREAK Injection
    [Documentation]    Verify BREAK inside FOR loop works correctly.
    Run Robot Test    ${CURDIR}/examples/control_structures_example.robot    Test With FOR And BREAK

Test FOR With CONTINUE Injection
    [Documentation]    Verify CONTINUE inside FOR loop works correctly.
    Run Robot Test    ${CURDIR}/examples/control_structures_example.robot    Test With FOR And CONTINUE

Test WHILE With BREAK Injection
    [Documentation]    Verify BREAK inside WHILE loop works correctly.
    Run Robot Test    ${CURDIR}/examples/control_structures_example.robot    Test With WHILE And BREAK

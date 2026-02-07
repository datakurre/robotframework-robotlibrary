*** Settings ***
Documentation    A resource file with reusable keywords.

*** Keywords ***
Greet User
    [Arguments]    ${name}
    Log    Hello, ${name}!
    RETURN    Hello, ${name}!

Add Numbers
    [Arguments]    ${a}    ${b}
    ${result}=    Evaluate    ${a} + ${b}
    RETURN    ${result}

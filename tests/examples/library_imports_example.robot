*** Settings ***
Documentation    Example suite that imports a Python library.
...              Demonstrates that RobotLibrary auto-imports Library statements
...              so that keywords from the library are available during injection.
Library          random

*** Test Cases ***
Test Randint
    ${result}=    Randint    ${1}    ${10}
    Should Be True    ${result} >= ${1}
    Should Be True    ${result} <= ${10}

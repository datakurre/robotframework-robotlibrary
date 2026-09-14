*** Settings ***
Documentation    Example suite that imports Python libraries, one of them with
...              an import argument. Demonstrates that RobotLibrary auto-imports
...              Library statements (args included) so that keywords from the
...              library are available during injection.
Library          random
Library          Screenshot    .

*** Test Cases ***
Test Randint
    ${result}=    Randint    ${1}    ${10}
    Should Be True    ${result} >= ${1}
    Should Be True    ${result} <= ${10}

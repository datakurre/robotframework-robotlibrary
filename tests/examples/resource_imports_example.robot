*** Settings ***
Documentation    Example suite that imports a resource file.
...              Demonstrates that RobotLibrary auto-imports resource files
...              so that keywords from the resource are available during injection.
Resource         keywords.resource

*** Variables ***
${USER_NAME}    World

*** Test Cases ***
Test Using Resource Keyword
    [Documentation]    Test that calls a keyword from an imported resource file.
    ${greeting}=    Greet User    ${USER_NAME}
    Should Be Equal    ${greeting}    Hello, ${USER_NAME}!

Test Using Resource Math Keyword
    [Documentation]    Test that calls a math keyword from the resource.
    ${result}=    Add Numbers    3    4
    Should Be Equal As Integers    ${result}    7

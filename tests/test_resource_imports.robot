*** Settings ***
Documentation    Meta-tests for resource file imports and keyword availability.
Library          RobotLibrary

*** Test Cases ***
Test Resource Keyword Injection
    [Documentation]    Verify that keywords from imported resource files are available.
    Run Robot Test    ${CURDIR}/examples/resource_imports_example.robot    Test Using Resource Keyword

Test Resource Math Keyword Injection
    [Documentation]    Verify that math keywords from resources work.
    Run Robot Test    ${CURDIR}/examples/resource_imports_example.robot    Test Using Resource Math Keyword

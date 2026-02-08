*** Settings ***
Documentation    Meta-tests for library imports and keyword availability.
Library          RobotLibrary

*** Test Cases ***
Test Library Keyword Injection
    [Documentation]    Verify that keywords from imported libraries are available.
    Run Robot Test    ${CURDIR}/examples/library_imports_example.robot    Test Randint

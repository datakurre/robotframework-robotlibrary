*** Settings ***
Documentation    Meta-tests for the runtime execution fallback (``_execute_at_runtime``).
...              The fallback runs whenever ``Run Robot Test`` / ``Run Robot Task`` is
...              invoked indirectly through a wrapper keyword rather than as a literal
...              top-level test step — the listener's ``start_test`` marker scan only
...              looks at direct test-body steps, so a wrapped call is never replaced
...              and instead executes for real, going through the fallback.
Library          RobotLibrary

*** Keywords ***
Run Test Via Wrapper
    [Documentation]    Calls Run Robot Test indirectly so the listener never sees it
    ...    as a top-level marker, forcing execution through the runtime fallback.
    [Arguments]    ${suite}    ${test}
    Run Robot Test    ${suite}    ${test}

*** Test Cases ***
Test Fallback With Resource Import
    [Documentation]    Verify the fallback path auto-imports resource files.
    Run Test Via Wrapper    ${CURDIR}/examples/resource_imports_example.robot
    ...    Test Using Resource Keyword

Test Fallback With Library Import
    [Documentation]    Verify the fallback path auto-imports libraries, including
    ...    a library imported with arguments.
    Run Test Via Wrapper    ${CURDIR}/examples/library_imports_example.robot
    ...    Test Randint

Test Fallback With Setup And Teardown
    [Documentation]    Verify the fallback path injects [Setup] and [Teardown].
    Run Test Via Wrapper    ${CURDIR}/examples/setup_teardown_example.robot
    ...    Test With Setup And Teardown

Test Fallback With Variables
    [Documentation]    Verify the fallback path injects scalar, list, and dict
    ...    variables, including a scalar variable declared with an empty value.
    Run Test Via Wrapper    ${CURDIR}/examples/variables_example.robot
    ...    Test With Composed Variable

Test Fallback Reports Missing Test Or Task
    [Documentation]    Verify the fallback path raises a clear error when the
    ...    target test/task cannot be found in the target suite.
    Run Keyword And Expect Error
    ...    Test or task 'Does Not Exist' not found in *
    ...    Run Test Via Wrapper    ${CURDIR}/examples/simple_task.robot
    ...    Does Not Exist

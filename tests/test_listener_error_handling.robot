*** Settings ***
Documentation    Meta-tests verifying that RobotLibrary's listener reports clear,
...              helpful errors for malformed or unresolvable "Run Robot Test"
...              markers, instead of silently doing nothing.
...
...              Every scenario in examples/listener_error_cases.robot is a
...              top-level marker, which is exactly what makes it interesting: the
...              listener only replaces top-level markers, so once it declines to
...              replace one (missing args, undefined variable, missing test, or
...              missing suite), that same marker is executed for real afterwards
...              and fails. That failure is the whole point of the scenario, so
...              the fixture is run out-of-process (via the Process library) to
...              keep it from affecting this suite's own results. Running the
...              child through ``coverage run -p`` still lets its execution of
...              RobotLibrary be measured and combined into the overall coverage
...              report.
Library          Process
Library          OperatingSystem

*** Variables ***
${ERROR_CASES}    ${CURDIR}/examples/listener_error_cases.robot

*** Test Cases ***
Test Listener Reports Malformed And Unresolvable Markers
    [Documentation]    Run the error-case fixture suite out-of-process and verify
    ...    every scenario in it fails for the expected reason.
    ${python}=    Evaluate    sys.executable    modules=sys
    ${result}=    Run Process
    ...    ${python}    -m    coverage    run    -p
    ...    --source\=src/RobotLibrary    -m    robot
    ...    --outputdir    ${OUTPUT_DIR}/listener_error_cases    ${ERROR_CASES}
    ...    cwd=${EXECDIR}
    Should Not Be Equal As Integers    ${result.rc}    0
    Should Contain    ${result.stdout}    4 tests, 0 passed, 4 failed
    Should Contain    ${result.stdout}
    ...    Keyword 'RobotLibrary.Run Robot Test' expected 2 non-named arguments, got 1.
    Should Contain    ${result.stdout}    Variable '\${UNDEFINED_MARKER_VAR}' not found.
    Should Contain    ${result.stdout}    Test or task 'Does Not Exist' not found in
    Should Contain    ${result.stdout}    File or directory to execute does not exist.

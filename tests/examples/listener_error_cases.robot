*** Settings ***
Documentation    Fixture suite used, out-of-process, by test_listener_error_handling.robot
...              to exercise the listener's own defensive branches: a malformed
...              marker (too few arguments), a marker whose arguments reference an
...              undefined variable, a target test/task that cannot be found, and a
...              target suite file that cannot be loaded. Every test case here is
...              *expected* to fail when this file is run directly.
Library          RobotLibrary

*** Test Cases ***
Test Marker Missing Args
    Run Robot Test    onlyonearg

Test Marker Undefined Variable
    Run Robot Test    ${UNDEFINED_MARKER_VAR}    Some Test

Test Marker Target Not Found
    Run Robot Test    ${CURDIR}/simple_task.robot    Does Not Exist

Test Marker Suite Not Found
    Run Robot Test    ${CURDIR}/does_not_exist.robot    Whatever

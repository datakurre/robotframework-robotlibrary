*** Settings ***
Documentation    Example task suite (uses *** Tasks *** instead of *** Test Cases ***).
...              Demonstrates that RobotLibrary works with both tests and tasks.

*** Variables ***
${NAME}    n/a

*** Tasks ***
Log name
    Log    Hello ${NAME}

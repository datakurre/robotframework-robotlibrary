*** Settings ***
Documentation    Example RPA task suite with variables and control structures.
...              Mirrors login_example.robot but uses *** Tasks *** instead of *** Test Cases ***.

*** Variables ***
${ITEM_NAME}     default_item
${QUANTITY}      3

*** Tasks ***
Process Item
    [Documentation]    A simple task with basic keywords.
    Log    Processing item ${ITEM_NAME}
    Should Not Be Empty    ${ITEM_NAME}

Task With FOR Loop
    [Documentation]    Task with a FOR loop.
    Log    Processing ${QUANTITY} items
    FOR    ${i}    IN RANGE    ${QUANTITY}
        Log    Processing item ${i}
        Should Be True    ${i} < ${QUANTITY}
    END
    Log    All items processed

Task With IF Structure
    [Documentation]    Task with IF/ELSE logic.
    IF    ${QUANTITY} > 0
        Log    Have ${QUANTITY} items to process
    ELSE
        Log    No items to process
    END

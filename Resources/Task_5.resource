*** Settings ***
Library    SeleniumLibrary
Library    String
Resource    ./App.resource

*** Keywords ***
Display Users With Spending
    ${row_count}    Get Element Count    ${table_row}
    ${counter}      Set Variable    1

    Log To Console    \n

    FOR    ${i}    IN RANGE    1    ${row_count + 1}
        ${name}    Get Text    (${table_row})[${i}]/td[2]
        ${name}    Replace String    ${name}    \n    ${SPACE}
        ${name}    Strip String      ${name}

        ${total_spent}  Get Text    (${table_row})[${i}]/td[5]
        ${amount}       Evaluate    float("${total_spent}".replace('$','').replace(',','').strip())

        IF    ${amount} > 0
            Log To Console    ${counter}. ${name}: ${total_spent}
            ${counter}    Evaluate    ${counter} + 1
        END
    END
    Log To Console    \n

Calculate Total Spending
    ${row_count}    Get Element Count    ${table_row}
    ${total}        Set Variable    0.0

    FOR    ${i}    IN RANGE    1    ${row_count + 1}
        ${total_spent}  Get Text    (${table_row})[${i}]/td[5]
        ${amount}       Evaluate    float("${total_spent}".replace('$','').replace(',','').strip())
        ${total}        Evaluate    ${total} + ${amount}
    END

    # Format the total with $ and 2 decimal places
    ${formatted_total}    Evaluate    "$%.2f" % ${total}
    Log To Console    \n
    Log To Console    ===================================
    Log To Console    Total Customer Spending: ${formatted_total}
    Log To Console    ===================================
    RETURN    ${total}    ${formatted_total}

Validate Total Spending
    [Arguments]    ${total}    ${formatted_total}
    ${threshold}    Set Variable    3500.0

    IF    ${total} >= ${threshold}
        Log To Console    PASS: Total spending (${formatted_total}) meets minimum threshold ($${threshold})
        Log To Console    ==================================================================\n
    ELSE
        Log To Console    FAIL: Total spending (${formatted_total}) is below minimum threshold ($${threshold})
        Log To Console    ==================================================================\n
        Fail    Total spending (${formatted_total}) is below minimum threshold ($${threshold})
    END

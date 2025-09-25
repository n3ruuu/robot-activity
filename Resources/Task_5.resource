*** Settings ***
Library    SeleniumLibrary
Library    String
Variables    ../Variables/customer_variables.py
Variables    ../Variables/variables.py

*** Keywords ***
Display Users With Spending
    ${row_count}=    Get Element Count    ${table_row}
    ${counter}=      Set Variable    1

    Log To Console    \n

    FOR    ${i}    IN RANGE    1    ${row_count + 1}
        ${name}=         Get Text    (${table_row})[${i}]/td[2]
        ${name}=         Replace String    ${name}    \n    ${SPACE}
        ${name}=         Strip String      ${name}

        ${total_spent}=  Get Text    (${table_row})[${i}]/td[5]
        ${amount}=       Evaluate    float("${total_spent}".replace('$','').replace(',','').strip())

        IF    ${amount} > 0
            Log To Console    ${counter}. ${name}: ${total_spent}
            ${counter}=    Evaluate    ${counter} + 1
        END
    END
    Log To Console    \n

Calculate Total Spending
    ${row_count}=    Get Element Count    ${table_row}
    ${total}=        Set Variable    0.0

    FOR    ${i}    IN RANGE    1    ${row_count + 1}
        ${total_spent}=  Get Text    (${table_row})[${i}]/td[5]
        ${amount}=       Evaluate    float("${total_spent}".replace('$','').replace(',','').strip())
        ${total}=        Evaluate    ${total} + ${amount}
    END

    # Format the total with $ and 2 decimal places
    ${formatted_total}=    Evaluate    "$%.2f" % ${total}
    Log To Console    \t===================================
    Log To Console    \tTotal Customer Spending: ${formatted_total}
    [Return]    ${total}    ${formatted_total}

Validate Total Spending
    [Arguments]    ${total}    ${formatted_total}
    ${threshold}=    Set Variable    3500.0

    Log To Console    \t===================================\n

    IF    ${total} < ${threshold}
        Log To Console    \tFAIL: Total spending (${formatted_total}) is below minimum threshold ($3,500)
    ELSE
        Log To Console    \tPASS: Total spending (${formatted_total}) meets minimum threshold ($3,500)
    END
    Log To Console    \t=================================================================\n
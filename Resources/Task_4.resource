*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Variables   ../Variables/customer_variables.py
Resource    ./App.resource

*** Keywords ***
Log All Users From Table
    ${row_count}=    Get Element Count    ${table_row}
    FOR    ${i}    IN RANGE    1    ${row_count + 1}
        Log To Console    ====== User ${i} ======\n
    
        ${name}=    Get Text    (${table_row})[${i}]/td[2]
        # Remove extra initials or prefixes (e.g., single letters)
        ${name_parts}=    Split String    ${name}
        ${filtered_name}=    Evaluate    " ".join([part for part in ${name_parts} if len(part) > 1])

        ${last_seen}=     Get Text    (${table_row})[${i}]/td[3]
        ${orders}=        Get Text    (${table_row})[${i}]/td[4]
        ${total_spent}=   Get Text    (${table_row})[${i}]/td[5]
        ${latest_purchase}=  Get Text    (${table_row})[${i}]/td[6]
        ${latest_purchase}=  Set Variable If    '${latest_purchase}' == ''    N/A    ${latest_purchase}
    

        ${has_newsletter}=  Get Element Attribute    (${table_row})[${i}]/td[7]//*[name()='svg']    aria-label
        # Get all span elements inside td[8]
        @{span_elements}=    Get WebElements    (${table_row})[${i}]/td[8]//span

        # Extract text from each span
        @{segments_list}=    Create List
        FOR    ${span}    IN    @{span_elements}
            ${text}=    Get Text    ${span}
            Append To List    ${segments_list}    ${text.strip()}
        END

        # Handle empty segments
        IF    @{segments_list} == []
            ${segments_clean}=    Set Variable    N/A
        ELSE
            ${segments_clean}=    Evaluate    ', '.join(${segments_list})
        END

        # Log everything
        Log To Console    Name: ${filtered_name}
        Log To Console    Last seen: ${last_seen}
        Log To Console    Orders: ${orders}
        Log To Console    Total spent: ${total_spent}
        Log To Console    Latest purchase: ${latest_purchase}
        Log To Console    Has Newsletter: ${has_newsletter}
        Log To Console    Segments: ${segments_clean}\n
    END



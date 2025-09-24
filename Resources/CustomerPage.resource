*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Resource    ./App.resource
Variables   ../Variables/customer_variables.py

*** Keywords ***
Create User
    [Arguments]        ${user}
    Click Element      ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname} 
    Input Text         ${customers_txt_firstname}    ${user["name"].split(" ")[0]}
    Input Text         ${customers_txt_lastname}     ${user["name"].split(" ")[1]}
    # Convert entire email to lowercase
    ${email}    Evaluate    "${user['email'].lower()}"
    Clear And Input Text    ${customers_txt_email}    ${email}
    Input Text         ${customers_txt_birthday}     ${user["birthday"]}
    Input Text         ${customers_txt_address}      ${user["address"]["street"]} ${user["address"]["suite"]}
    Input Text         ${customers_txt_city}         ${user["address"]["city"]}
    Input Text         ${customers_txt_stateAbbr}    ${user["stateAbbr"]}
    Input Text         ${customers_txt_zipcode}      ${user["address"]["zipcode"]}
    Input Text         ${customers_txt_password}     ${user["password"]}
    Input Text         ${customers_txt_confirm_password}     ${user["password"]}
    Click Element      ${customers_btn_save}
    Wait Until Page Contains    Customer created

Update Customer Row
    [Arguments]    ${row_index}    ${user}
    # Click the row to open the edit modal
    Click Element    //*[@id="main-content"]/div/div[1]/div[2]/div/div[2]/table/tbody/tr[${row_index}]
    Wait Until Element Is Visible    ${customers_txt_firstname}
    Fill Customer Form    ${user}
    Click Element    ${customers_btn_save}
    Wait Until Page Contains    Customer updated


Verify User Is Added
    [Arguments]    ${user}
    Go To Customers Page
    Wait Until Element Is Not Visible    (${table_row})[1]//td//div[contains(@class,"MuiAvatar-colorDefault") and text()]
    Wait Until Element Is Visible    (${table_row})[1]//td//div[contains(@class, "MuiAvatar-colorDefault") and text()]
    ${fetched_name}    Get Text    (${table_row})[1]//td[2]
    IF    "\\n" in """${fetched_name}"""
        ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    END
    Should Be Equal As Strings    ${user["name"].split(" ")[0]} ${user["name"].split(" ")[1]}    ${fetched_name}

Verify User Is Updated
    [Arguments]    ${row_index}    ${user}
    Go To Customers Page
    ${fetched_name}    Get Text    (//table//tbody//tr)[${row_index}]//td[2]
    IF    "\\n" in """${fetched_name}"""
        ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    END
    Should Be Equal As Strings    ${user["name"]}    ${fetched_name}


Go To Customers Page
    Click Element    ${nav_btn_customers}
    Wait Until Element Is Visible    //table//tbody//tr

Log All Users From Table
    ${row_count}=    Get Element Count    //table//tbody//tr
    FOR    ${i}    IN RANGE    1    ${row_count + 1}
        Log To Console    ====== User ${i} ======\n
        ${name}=          Get Text    (//table//tbody//tr)[${i}]/td[2]
        ${last_seen}=     Get Text    (//table//tbody//tr)[${i}]/td[3]
        ${orders}=        Get Text    (//table//tbody//tr)[${i}]/td[4]
        ${total_spent}=   Get Text    (//table//tbody//tr)[${i}]/td[5]
        ${latest_purchase}=  Get Text    (//table//tbody//tr)[${i}]/td[6]
        ${has_newsletter}=  Get Element Attribute    (//table//tbody//tr)[${i}]/td[7]//*[name()='svg']    aria-label
        # Get all span elements inside td[8], including spans inside all divs
        @{span_elements}=    Get WebElements    (//table//tbody//tr)[${i}]/td[8]//span

        # Extract text from each span and store in a list
        @{segments_list}=    Create List
        FOR    ${span}    IN    @{span_elements}
            ${text}=    Get Text    ${span}
            Append To List    ${segments_list}    ${text.strip()}
        END
    
        # Join all span texts with comma
        ${segments_clean}=    Evaluate    ', '.join(${segments_list})



        Log To Console    Name: ${name}
        Log To Console    Last seen: ${last_seen}
        Log To Console    Orders: ${orders}
        Log To Console    Total spent: ${total_spent}
        Log To Console    Latest purchase: ${latest_purchase}
        Log To Console    Has Newsletter: ${has_newsletter}
        Log To Console    Segments: ${segments_clean}\n
    END


Fill Customer Form
    [Arguments]    ${user}
    # Split name into first_name and last_name (last word as last name)
    ${name_parts}    Split String    ${user["name"]}    separator= 
    ${last_name}     Set Variable    ${name_parts}[-1]
    ${first_name}    Evaluate    " ".join(${name_parts}[:-1])
    Clear And Input Text    ${customers_txt_firstname}    ${first_name}
    Clear And Input Text    ${customers_txt_lastname}     ${last_name}
    # Convert entire email to lowercase
    ${email}    Evaluate    "${user['email'].lower()}"
    Clear And Input Text    ${customers_txt_email}    ${email}
    Set Date Field           ${customers_txt_birthday}    ${user["birthday"]}
    Clear And Input Text    ${customers_txt_address}      ${user["address"]["street"]} ${user["address"]["suite"]}
    Clear And Input Text    ${customers_txt_city}         ${user["address"]["city"]}
    Clear And Input Text    ${customers_txt_stateAbbr}    ${user["stateAbbr"]}
    Clear And Input Text    ${customers_txt_zipcode}      ${user["address"]["zipcode"]}
    Clear And Input Text    ${customers_txt_password}     ${user["password"]}
    Clear And Input Text    ${customers_txt_confirm_password}     ${user["password"]}

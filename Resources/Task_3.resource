*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Variables   ../Variables/customer_variables.py
Resource    ./App.resource

*** Keywords ***
Update Customer Row
    [Arguments]    ${row_index}    ${user}
    # Click the row to open the edit modal
    Click Element    //*[@id="main-content"]/div/div[1]/div[2]/div/div[2]/table/tbody/tr[${row_index}]
    Wait Until Element Is Visible    ${customers_txt_firstname}
    Fill Customer Form    ${user}
    Click Element    ${customers_btn_save}
    Wait Until Page Contains    Customer updated

Fill Customer Form
    [Arguments]    ${user}
    ${clean_name}    Clean Name    ${user["name"]}
    ${last_name}    Evaluate    "${clean_name}".split()[-1]
    ${first_name}   Evaluate    " ".join("${clean_name}".split()[:-1])

    Clear And Input Text    ${customers_txt_firstname}    ${first_name}
    Clear And Input Text    ${customers_txt_lastname}     ${last_name}

    ${email}    Evaluate    "${user['email'].lower()}"
    Clear And Input Text    ${customers_txt_email}    ${email}

    Set Date Field    ${customers_txt_birthday}    ${user["birthday"]}

    Clear And Input Text    ${customers_txt_address}      ${user["address"]["street"]} ${user["address"]["suite"]}
    Clear And Input Text    ${customers_txt_city}         ${user["address"]["city"]}
    Clear And Input Text    ${customers_txt_stateAbbr}    ${user["stateAbbr"]}
    Clear And Input Text    ${customers_txt_zipcode}      ${user["address"]["zipcode"]}
    Clear And Input Text    ${customers_txt_password}     ${user["password"]}
    Clear And Input Text    ${customers_txt_confirm_password}     ${user["password"]}
    
Verify User Is Updated
    [Arguments]    ${row_index}    ${user}
    Go To Customers Page
    Sleep    1s
    ${fetched_name}    Get Text    (${table_row})[${row_index}]//td[2]
    IF    "\\n" in """${fetched_name}"""
        ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    END

    ${clean_fetched_name}    Clean Name    ${fetched_name}
    ${clean_user_name}       Clean Name    ${user["name"]}

    Should Be Equal As Strings    ${clean_user_name}    ${clean_fetched_name}

Clean Name
    [Arguments]    ${name}
    ${titles_suffixes}    Create List    mr.    mrs.    ms.    dr.    jr.    sr.    iii    iv    v
    ${name_parts}    Split String    ${name}
    @{clean_parts}    Create List
    FOR    ${word}    IN    @{name_parts}
        ${lower}    Convert To Lowercase    ${word}
        Run Keyword Unless    '${lower}' in @{titles_suffixes}    Append To List    ${clean_parts}    ${word}
    END
    ${clean_name}    Evaluate    " ".join(${clean_parts})
    RETURN    ${clean_name}

Update And Verify Multiple Users
    [Arguments]    ${users}    ${start_row}
    ${row_index}    Set Variable    ${start_row}
    FOR    ${user}    IN    @{users}
        Update Customer Row    ${row_index}    ${user}
        Verify User Is Updated    ${row_index}    ${user}
        ${row_index}    Evaluate    ${row_index}+1
    END
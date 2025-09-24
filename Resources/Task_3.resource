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
    # List of prefixes/titles and suffixes to remove
    ${titles_suffixes}=    Create List    mr.    mrs.    ms.    dr.    jr.    sr.    iii    iv    v

    # Split name and remove any titles/suffixes
    ${name_parts}=    Split String    ${user["name"]}
    @{clean_parts}=    Create List
    FOR    ${word}    IN    @{name_parts}
        ${lower}=    Convert To Lowercase    ${word}
        Run Keyword Unless    '${lower}' in @{titles_suffixes}    Append To List    ${clean_parts}    ${word}
    END

    # Now last word is the last name, rest is first name
    ${last_name}=    Set Variable    ${clean_parts}[-1]
    ${first_name}=    Evaluate    " ".join(${clean_parts}[:-1])

    # Fill form
    Clear And Input Text    ${customers_txt_firstname}    ${first_name}
    Clear And Input Text    ${customers_txt_lastname}     ${last_name}

    # Convert entire email to lowercase
    ${email}=    Evaluate    "${user['email'].lower()}"
    Clear And Input Text    ${customers_txt_email}    ${email}

    # Set birthday
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
    ${fetched_name}=    Get Text    (//table//tbody//tr)[${row_index}]//td[2]

    # Remove newlines
    ${fetched_name}=    Replace String    ${fetched_name}    \n    ${EMPTY}

    # Define titles and suffixes to remove
    ${titles_suffixes}=    Create List    mr.    mrs.    ms.    dr.    jr.    sr.    iii    iv    v

    # Split the fetched name and remove any titles/suffixes
    ${name_words}=    Split String    ${fetched_name}
    @{filtered_words}=    Create List
    FOR    ${word}    IN    @{name_words}
        ${lower}=    Convert To Lowercase    ${word}
        Run Keyword Unless    '${lower}' in @{titles_suffixes}    Append To List    ${filtered_words}    ${word}
    END
    ${clean_fetched_name}=    Evaluate    " ".join(${filtered_words})

    # Do the same for user input name
    ${user_name_parts}=    Split String    ${user["name"]}
    @{user_filtered}=    Create List
    FOR    ${word}    IN    @{user_name_parts}
        ${lower}=    Convert To Lowercase    ${word}
        Run Keyword Unless    '${lower}' in @{titles_suffixes}    Append To List    ${user_filtered}    ${word}
    END
    ${clean_user_name}=    Evaluate    " ".join(${user_filtered})

    # Compare
    Should Be Equal As Strings    ${clean_user_name}    ${clean_fetched_name}


*** Settings ***
Library    SeleniumLibrary
Variables    ../Variables/variables.py

*** Keywords ***
Launch Browser
    [Arguments]    ${url}    ${element_to_wait}=${login_txt_username}
    Open Browser    ${url}    chrome    options=add_argument("--start-maximized")
    Wait Until Keyword Succeeds    5x    .5s    Wait Until Element Is Visible    ${element_to_wait}

Login User
    [Arguments]    ${username}=${USERNAME}    ${password}=${PASSWORD}
    Input Text    ${login_txt_username}    ${username}
    Input Text    ${login_txt_password}    ${password}
    Click Button    ${login_btn_submit}

    ${status}     Run Keyword and Return Status    Wait Until Element Is Visible    ${dashboard_hdr}     timeout=2s

    IF    ${status}
        Log To Console   Login successful
    ELSE
        Log To Console    Login failed
    END

Refresh Current Page   
    Click Button    ${btn_refresh}
    Wait Until Element Is Visible    ${loading_icon}
    Wait Until Element Is Not Visible    ${loading_icon}

Clear And Input Text
    [Arguments]    ${locator}    ${text}
    Press Keys    ${locator}    COMMAND+a     BACKSPACE
    Input Text    ${locator}    ${text}

Set Date Field
    [Arguments]    ${locator}    ${date}
    # Clear the field by sending TAB + DELETE repeatedly
    Press Keys    ${locator}    TAB    DELETE
    Press Keys    ${locator}    TAB    DELETE
    Press Keys    ${locator}    TAB    DELETE
    # Type the new date
    Input Text    ${locator}    ${date}
    # Optionally press TAB to trigger blur/onChange
    Press Keys    ${locator}    TAB

Go To Customers Page
    Click Element    ${nav_btn_customers}
    Wait Until Element Is Visible    ${table_row}

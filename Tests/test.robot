*** Settings ***
Library    ../Library/CustomLibrary.py
Resource    ../Resources/CustomerPage.resource
Variables   ../Variables/variables.py

Suite Setup    Launch Browser    ${URL}
Suite Teardown    Close Browser

*** Test Cases ***
TEST-000001
    [Documentation]    Login User
    Sleep    1s
    Login User

TEST-000002
    [Documentation]    Add the first 5 users from API and verify each one
    ${users}    Get First Five Users
    Go To Customers Page
    FOR    ${user}    IN    @{users}
        Create User    ${user}
        Verify User Is Added    ${user}
    END

TEST-000003
    [Documentation]    Update rows 6-10 with last 5 users from API
    ${users}    Get Last Five Users
    ${row_index}    Set Variable    6
    FOR    ${user}    IN    @{users}
        Update Customer Row    ${row_index}    ${user}
        Verify User Is Updated    ${row_index}    ${user}
        ${row_index}=    Evaluate    ${row_index}+1
    END

TEST-000004
    # Login User
    Go To Customers Page
    Log All Users From Table

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

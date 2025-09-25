*** Settings ***
Library    ../Library/CustomLibrary.py
Resource    ../Resources/App.resource
Resource    ../Resources/Task_1.resource
Resource    ../Resources/Task_2.resource
Resource    ../Resources/Task_3.resource
Resource    ../Resources/Task_4.resource
Resource    ../Resources/Task_5.resource
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
    Capture Page Screenshot

TEST-000003
    [Documentation]    Update rows 6-10 with last 5 users from API and verify each one 
    ${users}    Get Last Five Users
    ${row_index}    Set Variable    6
    FOR    ${user}    IN    @{users}
        Update Customer Row    ${row_index}    ${user}
        Verify User Is Updated    ${row_index}    ${user}
        ${row_index}    Evaluate    ${row_index}+1
    END
    Capture Page Screenshot

TEST-000004
    # Login User
    Go To Customers Page
    Log All Users From Table

TEST-000005
    # Login User
    Go To Customers Page
    ${total}    ${formatted_total}    Calculate Total Spending
    Validate Total Spending    ${total}    ${formatted_total}


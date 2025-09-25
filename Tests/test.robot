*** Settings ***
Library    ../Library/CustomLibrary.py
Resource    ../Resources/App.resource
Resource    ../Resources/Task_1.resource
Resource    ../Resources/Task_2.resource
Resource    ../Resources/Task_3.resource
Resource    ../Resources/Task_4.resource
Resource    ../Resources/Task_5.resource
Variables   ../Variables/variables.py

Suite Setup       Launch Browser    ${URL}
Suite Teardown    Close Browser

*** Test Cases ***
TEST-000001-2
    [Documentation]    Login the user, fetch the first 5 users from the API, create them in the system, and verify each one is added successfully.
    Sleep    1s
    Login User
    ${users}    Get First Five Users
    Go To Customers Page
    Create And Verify Multiple Users    ${users}
    Capture Page Screenshot
    
TEST-000003
    [Documentation]    Fetch the last 5 users from the API, update rows 6–10 in the customer table with these users, and verify the updates are successful.
    ${users}    Get Last Five Users
    Update And Verify Multiple Users    ${users}    6
    Capture Page Screenshot

TEST-000004
    [Documentation]    Navigate to the customers page and log all users currently displayed in the customer table for validation and auditing.
    Go To Customers Page
    Log All Users From Table

TEST-000005
    [Documentation]    Navigate to the customers page, calculate the total spending of all customers, and validate that the computed value matches the displayed formatted total.
    Login User
    Go To Customers Page
    ${total}    ${formatted_total}    Calculate Total Spending
    Validate Total Spending    ${total}    ${formatted_total}

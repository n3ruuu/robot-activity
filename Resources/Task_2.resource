*** Settings ***
Library    SeleniumLibrary
Library    String
Variables   ../Variables/customer_variables.py
Variables     ../Variables/variables.py
Resource    ./App.resource

*** Keywords ***
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

*** Settings ***
Library    SeleniumLibrary
Library    String
Variables   ../Variables/customer_variables.py
Resource    ./App.resource
Resource    ../Resources/Task_2.resource

*** Keywords ***
Create And Verify Multiple Users
    [Arguments]    ${users}
    FOR    ${user}    IN    @{users}
        Create User    ${user}
        Verify User Is Added    ${user}
    END

Create User
    [Arguments]    ${user}
    Click Element    ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname} 
    Input Text    ${customers_txt_firstname}    ${user["name"].split(" ")[0]}
    Input Text    ${customers_txt_lastname}    ${user["name"].split(" ")[1]}
    # Convert entire email to lowercase
    ${email}    Evaluate    "${user['email'].lower()}"
    Clear And Input Text    ${customers_txt_email}    ${email}
    Input Text    ${customers_txt_birthday}    ${user["birthday"]}
    Input Text    ${customers_txt_address}    ${user["address"]["street"]} ${user["address"]["suite"]}
    Input Text    ${customers_txt_city}    ${user["address"]["city"]}
    Input Text    ${customers_txt_stateAbbr}    ${user["stateAbbr"]}
    Input Text    ${customers_txt_zipcode}    ${user["address"]["zipcode"]}
    Input Text    ${customers_txt_password}    ${user["password"]}
    Input Text    ${customers_txt_confirm_password}    ${user["password"]}
    Click Element    ${customers_btn_save}
    Wait Until Page Contains    Customer created

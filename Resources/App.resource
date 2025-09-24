*** Settings ***
Library    SeleniumLibrary
Variables    ../Variables/variables.py

*** Keywords ***
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

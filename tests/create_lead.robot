*** Settings ***
Documentation       After a deployment, prove the destination org still lets a person create a Lead.
...                 Short on purpose: log in, create one Lead with generated values, check it saved.
Resource            ../resources/login.robot
Suite Setup         Setup Browser
Suite Teardown      End Suite

*** Test Cases ***
Create A Lead In The Deployed Org
    Login To Target Org
    ${first}=       FakerLibrary.First Name
    ${last}=        FakerLibrary.Last Name
    ${company}=     FakerLibrary.Company
    GoTo            ${INSTANCE}/lightning/o/Lead/new
    UseModal        On
    TypeText        First Name    ${first}
    TypeText        Last Name     ${last}
    TypeText        Company       ${company}
    ClickText       Save          partial_match=False
    UseModal        Off
    VerifyText      ${first} ${last}    timeout=30
    VerifyText      ${company}
    Log             Created Lead ${first} ${last} at ${company}    console=True

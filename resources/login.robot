*** Settings ***
Documentation       One login for both ways this job runs.
...                 Run by Copado CI/CD (a user story test or a quality gate): Copado hands the run
...                 ${loginUrl}, a one-click login link to the DESTINATION environment minted from its
...                 credential, so the test needs no stored password.
...                 Run on its own in CRT: no ${loginUrl} arrives, so it logs in with the job's JWT
...                 variables (client_id / username / private_key in CRT's variables, never in this repo).
Library             QForce
Library             QWeb
Library             String
Library             FakerLibrary

*** Variables ***
${loginUrl}         ${EMPTY}
${client_id}        NOT_SET
${username}         NOT_SET
${private_key}      NOT_SET
# Copado passes this from the Test record's configuration so the log says which route ran it.
${route}            run on its own in CRT

*** Keywords ***
Setup Browser
    Set Library Search Order    QForce    QWeb
    Open Browser    about:blank    chrome
    SetConfig    LineBreak    ${EMPTY}
    SetConfig    DefaultTimeout    20s

End Suite
    Close All Browsers

Login To Target Org
    [Documentation]    Copado CI/CD first (${loginUrl}), JWT second. Sets ${INSTANCE} either way.
    Log    Triggered by: ${route}    console=True
    IF    '${loginUrl}' != '${EMPTY}'
        ${host}=    Get Regexp Matches    ${loginUrl}    (https://[^/?]+)    1
        GoTo    ${loginUrl}
        Set Suite Variable    ${INSTANCE}    ${host}[0]
        Log    Logged in through the Copado CI/CD loginUrl: ${INSTANCE}    console=True
    ELSE IF    '${client_id}' != 'NOT_SET'
        JwtAuthenticate    ${client_id}    ${username}    ${private_key}
        JwtLogin
        ${instance}=    GetInstanceUrl
        Set Suite Variable    ${INSTANCE}    ${instance}
        Log    Logged in with JWT: ${INSTANCE}    console=True
    ELSE
        Fail    No way to log in: Copado passed no loginUrl and the job has no client_id/username/private_key variables.
    END

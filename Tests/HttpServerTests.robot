*** Settings ***

Library  RequestsLibrary
Library  Collections

#Test Setup       Open Application    App A
#Test Teardown    Close Application
#Documentation    Example suite
#Suite Setup      Do Something    ${MESSAGE}
#Force Tags       example
#Library          SomeLibrary

*** Variables ***

${SERVER_URL}     http://localhost
${HEADER_KEY}     imsi

*** Test cases ***

No Header Test Case
    [Documentation]    Example test
    [Tags]   No Header
    Post Request Without Args   400
    Log  TEST123
    Log  ${CURDIR}
    #[Timeout] 10
    #:FOR    ${animal}    IN    cat    dog
    #\    Log    ${animal}
    #\    Log    2nd keyword
    #Log    Outside loop

Long Header Test Case
    Post Request With Args  ${HEADER_KEY}    12345678901234567   400

Incorrect Header Test Case
    Post Request With Args  ${HEADER_KEY}    `@   400

Many Headers Missing imsi
    ${post_headers}=  Create Dictionary
    Set To Dictionary    ${post_headers}    test1    test1
    Set To Dictionary    ${post_headers}    test2    test2
    Post Request With Many Headers  ${post_headers}  400

Many Headers Containing Incorrect imsi
    ${post_headers}=  Create Dictionary
    Set To Dictionary    ${post_headers}    ${HEADER_KEY}    `@
    Set To Dictionary    ${post_headers}    test1    test1
    Set To Dictionary    ${post_headers}    test2    test2
    Post Request With Many Headers  ${post_headers}  400

Many Headers Containing Correct imsi
    ${post_headers}=  Create Dictionary
    Set To Dictionary    ${post_headers}    ${HEADER_KEY}    123
    Set To Dictionary    ${post_headers}    test1    test1
    Set To Dictionary    ${post_headers}    test2    test2
    Post Request With Many Headers  ${post_headers}  200

Correct Header Test Case
    Post Request With Args  ${HEADER_KEY}    testHeader_123   200


#Normal test case
#    Example keyword    first argument    second argument

#Templated test case
#    [Template]    Example keyword
#    first argument    second argument

*** Keywords ***

Post Request Without Args
    [Arguments]  ${expected_resp_code}
    Create Session	loc	 ${SERVER_URL}
    ${resp}=	Post Request	loc	/
    Should Be Equal As Strings	${resp.status_code}	${expected_resp_code}

Post Request With Args
    [Arguments]  ${header_key}  ${header_value}  ${expected_resp_code}
    Create Session	loc	 ${SERVER_URL}
    ${post_headers}=  Create Dictionary
    Set To Dictionary    ${post_headers}    ${header_key}    ${header_value}
    ${resp}=	Post Request	loc	/   headers=${post_headers}
    Should Be Equal As Strings	${resp.status_code}	${expected_resp_code}
    #[Return] ...

Post Request With Many Headers
    [Arguments]  ${headers}  ${expected_resp_code}
    Create Session	loc	 ${SERVER_URL}
    ${resp}=	Post Request	loc	/   headers=${headers}
    Should Be Equal As Strings	${resp.status_code}	${expected_resp_code}
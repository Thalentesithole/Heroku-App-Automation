*** settings ***
Library   SeleniumLibrary
Library   RequestsLibrary
Library   String
Library   Collections
Library   Keyword.py


*** Variables ***
${URL}   https://the-internet.herokuapp.com/
${File_Path}  C:\\Users\\thale\\Desktop\\Robot Framework Assignment\\zero_bytes_file.txt
${SEARCH_PHRASE}   example
${API_URL}    https://jsonplaceholder.typicode.com/
  

*** Test Cases ***
Open Firefox Browser 
    SeleniumLibrary.Open Browser  ${URL} 

Navigate To Form Authentication 
    Click Link    link:Form Authentication

Extract Password And Username 
    ${description}=   Get Text   css=div.example
    ${username}=    Extract Credentials    ${description}    Enter
    ${password}=    Extract Credentials    ${description}    and
    Set Suite Variable    ${username}
    Set Suite Variable    ${password} 

Negative Login - Invalid username
    Input Text   id=username   Invalid
    Input Text   id=password   ${password}
    Click Button    css=button[type="submit"]

Negative Login - Invalid password
    Input Text   id=username   ${username}
    Input Text   id=password   Invalid
    Click Button    css=button[type="submit"]

Positive Login - Valid username and password
    Input Text   id=username   ${username}
    Input Text   id=password   ${password}
    Click Button    css=button[type="submit"]

Upload a file
    Go To    ${URL}
    Click Link    link:File Upload
    Choose File    id=file-upload   ${File_Path}
    Click Button    id=file-submit

Searching for a phrase
    Set Suite Variable    ${found_count}    0
    ${reload_count}=   Evaluate    0
    Go To    ${URL}
    WHILE    ${found_count} < 3
        Go To    ${URL}/dynamic_content
        ${page_text}=    Get Text    css=#content
        ${reload_count}=    Evaluate    ${reload_count} + 1
        Run Keyword If    '${SEARCH_PHRASE}' in '''${page_text}'''    Increment Found Count And Screenshot
    END

    Log    Phrase '${SEARCH_PHRASE}' found 3 times after ${reload_count} reloads.

GET and a POST Request to an API
    Create Session  api    ${API_URL}    verify=False

    # The GET Method
    ${get_response}=   GET On Session   api   /posts/1
    Log    GET Response Status: ${get_response.status_code}
    ${title}=   Get From Dictionary   ${get_response.json()}   title
    Log To Console    GET Response Title: ${title}
    Log    GET Response Title: ${title}

    # The POST Request
    ${post_data}=   Create Dictionary  title=foo  body=bar  userid=1
    ${post_response}=   POST On Session  api   /posts  json=${post_data}
    Log    POST Response Status: ${post_response.status_code}
    ${post_id}=   Get From Dictionary   ${post_response.json()}   id
    Log To Console    POST Response ID: ${post_id}
    Log    POST Response ID: ${post_id}

*** Keywords ***
Increment Found Count And Screenshot
    ${found_count}=  Evaluate    ${found_count} + 1
    Set Suite Variable    ${found_count}
    Log    Found count is now ${found_count}    INFO
    Capture Page Screenshot









   




#!/usr/bin/python3
import requests
url = "http://cyclonea0.mooo.com"
test_cases = ['union', 'form', 'tech', 'asia', 'account', 'Samuel', 'food', 'learn', 'birth']
responses = []
for word in test_cases:
    payload={'query': 'gun'}
    files=[]
    headers = {}
    response = requests.request("GET", url, headers=headers, data=payload, files=files)
    responses.append(response.status_code)
print(responses)

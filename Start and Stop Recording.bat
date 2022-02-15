
 
REM export a password for use with the system (no quotes)

more config.json | jq-win64.exe ".serviceUrl" >> temp.txt
set /p serviceUrl=<temp.txt
del -f temp.txt

more config.json | jq-win64.exe ".username" >> temp.txt
set /p username=<temp.txt
del -f temp.txt

more config.json | jq-win64.exe ".password" >> temp.txt
set /p password=<temp.txt
del -f temp.txt

more config.json | jq-win64.exe ".recordingStopperTime" >> temp.txt
set /p recordingStopperTime=<temp.txt
del -f temp.txt

more config.json | jq-win64.exe ".useCaseId" >> temp.txt
set /p useCaseId=<temp.txt
del -f temp.txt

more config.json | jq-win64.exe ".applicationIdentifier" >> temp.txt
set /p applicationIdentifier=<temp.txt
del -f temp.txt

:start

curl -X POST %serviceUrl%oauth/token -u "performanceDashboardClientId:ljknsqy9tp6123" -d "grant_type=password" -d "username=%username%" -d "password=%password%" >> temp.txt
more temp.txt | jq-win64.exe ".access_token" >> accessToken.txt
set /p accessToken=<accessToken.txt
del -f temp.txt
del -f accessToken.txt
if %accessToken%==null (goto :showMessage)
curl -v -H "Authorization: Bearer %accessToken%", -H "applicationIdentifier:%applicationIdentifier%" -X GET %serviceUrl%devaten/data/startRecording?usecaseIdentifier="customer" -i
for /l %%x in (1, 1, 2) do (
mongo -u user1 -p root localhost/Enter database name < customer.txt > out_customer_result.txt
)
curl -v -H "Authorization: Bearer %accessToken%", -H "applicationIdentifier:%applicationIdentifier%" -X GET %serviceUrl%devaten/data/stopRecording?usecaseIdentifier="customer&inputSource=batFile" -i

curl -v -H "Authorization: Bearer %accessToken%", -H "applicationIdentifier:%applicationIdentifier%" -X GET %serviceUrl%devaten/data/startRecording?usecaseIdentifier="customer" -i
for /l %%x in (1, 1, 2) do (
mongo -u user1 -p root localhost/Enter database name < Usecase2_Tax_rates_Queries > Result_Usecase2.txt
)
curl -v -H "Authorization: Bearer %accessToken%", -H "applicationIdentifier:%applicationIdentifier%" -X GET %serviceUrl%devaten/data/stopRecording?usecaseIdentifier="customer&inputSource=batFile" -i

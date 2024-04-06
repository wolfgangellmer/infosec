#SCRIPTNAME: Windows Logging nach BSI vorgaben einrichten

###### Importing bsi logging reccomendations with microsfot import tool version 04/2024
##### GPO import guide BSI https://www.bsi.bund.de/SharedDocs/Downloads/EN/BSI/Cyber-Security/SiSyPHuS/AP12/GPO_Guideline.pdf?__blob=publicationFile&v=3
##### GPO Templates https://www.bsi.bund.de/SharedDocs/Downloads/EN/BSI/Cyber-Security/SiSyPHuS/AP12/Workpackage12_GPOs_V1_1.html?nn=1011474
##### Setting Guide BSI https://www.bsi.bund.de/SharedDocs/Downloads/EN/BSI/Cyber-Security/SiSyPHuS/AP10/Logging_Configuration_Guideline.pdf?__blob=publicationFile&v=5

.\LGPO.exe /g "Logging (ND, NE, HD) - Computer"
.\BSIEVTLOGSETTINGS.ps1
# sonar-report
Sonar-report to DefectDojo

# Usage
-Run Docker image
```
docker run -e SONARTOKEN='<sonar_key>' \
	-e ORGANIZATION='<sonar_organization>' \
	-e COMPONENTKEY='<project_id>' \
	-e DOJOKEY='<dojo_apikey>' \
	-e DOJOIP='<dojoip:port>' \
	-e EGID='<engagement_id>' cyberkru/sonar-report
```

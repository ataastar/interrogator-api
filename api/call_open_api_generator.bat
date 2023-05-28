SET PATH=%PATH%;c:\Users\amolnar\.jdks\openjdk-18.0.2.1\bin\
"c:\Program Files\nodejs\openapi-generator-cli.cmd" generate -g typescript-angular -i ./interrogator-api.yaml -o ../../interrogator-api-ts-oa  --additional-properties npmName=interrogator-api-ts-oa,snapshot=false,ngVersion=19.0.1,npmVersion=0.0.1

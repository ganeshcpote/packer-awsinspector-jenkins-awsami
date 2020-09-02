import boto3
import os, sys
import datetime, time
import xml.etree.cElementTree as etree

# initialize boto library for AWS Inspector
client = boto3.client('inspector')

# set assessment template for stack
assessmentTemplate  = 'arn:aws:inspector:us-east-1:xxxx:target/0-V4iBfnSO/template/0-VBwTCdd4' #update assessmentTemplate arn here

# start assessment run
assessment = client.start_assessment_run(
	assessmentTemplateArn = assessmentTemplate,
	assessmentRunName = "inspector-packer-build-"+ str(datetime.datetime.now())
)

# wait for the assessment to finish
time.sleep(1200)

# list findings
if client.can_paginate('list_findings'):
    findings= {'findingArns': []}
    paginator = client.get_paginator('list_findings')
    page_interator = paginator.paginate(assessmentRunArns=[assessment['assessmentRunArn']],maxResults=500)
    for page in page_interator:
        findings['findingArns'] = findings['findingArns'] + page['findingArns']
else: findings = client.list_findings(assessmentRunArns=[assessment['assessmentRunArn']],maxResults=500)

# describe findings and output to JUnit 
testsuites = etree.Element("testsuites")
testsuite = etree.SubElement(testsuites, "testsuite", name="Common Vulnerabilities and Exposures-1.1")

for item in findings['findingArns']:
	description = client.describe_findings(
		findingArns=[
			item,
		],
		locale='EN_US'
	)

	for item in description['findings']:
		testcase = etree.SubElement(testsuite, "testcase", name=item['severity'] + ' - ' + item['title'])
		etree.SubElement(testcase, "error", message=item['description']).text = item['recommendation']

tree = etree.ElementTree(testsuites)
tree.write("inspector-junit-report.xml")

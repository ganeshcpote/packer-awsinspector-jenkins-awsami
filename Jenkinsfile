pipeline {
  agent any

  parameters {
        choice(choices: ['ubuntu', 'amazonlinux'], description: 'Specify OS for AMI', name: 'os_name' )
        choice(choices: ['ubuntu', 'jdk1.8', 'activemq', 'elasticsearch'], description: 'Specify installation package for AMI (Only for Ubuntu...)', name: 'install_package' )
        choice(choices: ['ami-07ebfd5b3428b6f4d', 'ami-0b22c910bce7178b6'], description: 'Specify base AMI for creating new AMI', name: 'aws_source_ami' )
    }
  stages {
    stage('Packer validate') {
      steps {
        withCredentials([
            usernamePassword(credentialsId: 'JenkinsAWS',
              usernameVariable: 'aws_access_key',
              passwordVariable: 'aws_secret_key')
          ]) {
            sh '/opt/packer/packer validate -var \"aws_source_ami=${aws_source_ami}\"  -var \"install_package=${install_package}\" -var \"aws_access_key=${aws_access_key}\" -var \"aws_secret_key=${aws_secret_key}\" ${os_name}.json'
          }
      }
    }
    stage('Packer Build Approval') {
        steps { 
            input 'Do you want to build AWS AMI?'
        }
    }
    stage('Packer Build & Execute Inspector') {
      steps {
        withCredentials([
            usernamePassword(credentialsId: 'JenkinsAWS',
              usernameVariable: 'aws_access_key',
              passwordVariable: 'aws_secret_key')
          ]) {
            sh '/opt/packer/packer build -var \"aws_source_ami=${aws_source_ami}\" -var \"install_package=${install_package}\" -var \"aws_access_key=${aws_access_key}\" -var \"aws_secret_key=${aws_secret_key}\" ${os_name}.json'
        }
            sh 'echo AMI_ID=$(jq -r \'.builds[-1].artifact_id\' manifest.json | cut -d \":\" -f2)'
            sh 'echo ${AMI_ID}'
      }
    }
    stage('Update Parameter Store for AMI') {
      steps {
        script{
          if ("${os_name}" == "ubuntu"){
            sh 'aws ssm put-parameter --name "/golden-ami/${os_name}/${install_package} " --value "$(jq -r \'.builds[-1].artifact_id\' manifest.json | cut -d \":\" -f2)" --type String --overwrite'
          }
          else{
            sh 'aws ssm put-parameter --name "/golden-ami/${os_name}/amazonlinux " --value "$(jq -r \'.builds[-1].artifact_id\' manifest.json | cut -d \":\" -f2)" --type String --overwrite'
          }
        }
      }
    }
    stage('Generated Inspector Report') {
      steps {
        junit allowEmptyResults: true, testResults: 'inspector-junit-report.xml'
         script {
            currentBuild.result = 'Success'
          }
      }
    }
  }
  post {
        always {  
            archiveArtifacts artifacts: 'manifest.json, inspector-junit-report.xml'
            cleanWs()
        }
    }
}
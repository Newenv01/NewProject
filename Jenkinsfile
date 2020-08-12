currentBuild.displayName = "LCADPIP-#"+currentBuild.number

pipeline{
  options { timeout(time: 3, unit: 'MINUTES') }
  //options { timestamps() }
  agent any

  environment {
    Remote_ID = deployevn()
  }
  
  stages{
    stage('SCM CheckOut'){
      steps{
           checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://github.com/Newenv01/NewProject.git']]])
      }
    }
    stage('Build'){
      steps{
           script {
                  sh "chmod +x -R ${env.WORKSPACE}"
                  //sh "${env.WORKSPACE}/../${env.JOB_NAME}@script/script.sh"
                  try {
                    //dir('/home/testenv/'){    
                    sh "sh /home/testenv/one.sh"
                    sh "echo ${env.WORKSPACE}"
                    sh "/usr/bin/cp /home/testenv/*.* ${env.WORKSPACE}/"
                    sh "/usr/bin/gzip -f ${env.WORKSPACE}/*.sh"
                    //sh "/usr/bin/bash /root/test/one.sh"
                    //sh 'pwr=$(pwd); $pwr/script.sh "/test/root/one.sh"'
                    sh "ls -ltr"
                    sh "echo $BUILD_TAG"
                    //}
                  } catch (err) {
                      echo err.getMessage()
                      echo "Error detected - BUILD Failure."
                      currentBuild.result = 'FAILURE'
                    mail to: 'balu0priya1@gmail.com',
                           subject: "FAILED - Job '${JOB_NAME}' '${BUILD_NUMBER}'",
                           body: "Dear Team,\n\n Please go to ${BUILD_URL} and verify the build.\n\nRegards\nSupport Team."
                  }
           } 
       }
    }
    stage('Upload'){
      steps{
        sh "echo \"${env.BUILD_TAG}\""
        script {
          buildName = 'LCADPB'
          buildNumber = "${env.BUILD_NUMBER}"
          buildEnvironment = "${env.BRANCH_NAME}"
          def server = Artifactory.server "JfrogServer"
          def uploadSpec = '{"files": [{"pattern": "*.gz", "target": "LCADPB/"}]}'

          def buildInfo = Artifactory.newBuildInfo()
          buildInfo.name = buildName + '-' + buildEnvironment
          //buildInfo.number = "LCAD_Release_Number"
          server.upload spec: uploadSpec, buildInfo: buildInfo
          server.publishBuildInfo buildInfo
        }
      }
    }
    stage('Deploy Files to Remote'){
      steps{
        //sshagent(['RemoteMac']) {
        sshagent(["${Remote_ID}"]) {  
            sh """
                 scp -o StrictHostKeyChecking=no ${env.WORKSPACE}/*.gz ec2-user@172.31.2.140:/home/ec2-user/testdir/
            """
        }
      }
    }
  }
}

def deployevn() {
  script {
      if ( env.BRANCH_NAME == "master" || env.BRANCHNAME == "Master" || env.BRANCHNAME == "MASTER" )
      {
           def RemoteID="RemoteMAc"
           return RemoteID
      }
      else if ( env.BRANCH_NAME == "dev" || env.BRANCHNAME == "Dev" || env.BRANCHNAME == "DEV" )
      {
           def RemoteID="RemoteID01"
           return RemoteID
      }
    }
}

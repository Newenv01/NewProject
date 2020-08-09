pipeline{
  options { timeout(time: 3, unit: 'MINUTES') }
  //options { timestamps() }
  agent any
    
  stages{
    stage('SCM CheckOut'){
      //steps{[$class: 'WsCleanup']}
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
                    //sh "echo $TAG_NAME"
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
    stage('Artifactory'){
      steps{
        sh "echo \"${env.BUILD_TAG} and ${env.TAG_UNIXTIME} and ${env.TAG_NAME}\""
        script {
          buildName = 'LCADPB'
          buildNumber = "${env.BUILD_NUMBER}"
          buildEnvironment = "$BRANCH_NAME"
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
  }
}

currentBuild.displayName = "LCADPIP-#"+currentBuild.number

pipeline{
  options { timeout(time: 3, unit: 'MINUTES') }
  //options { timestamps() }
  agent any

  environment {
    depenv = "${env.JOB_NAME}".split('_').last()
    Remote_ID = deployevn(depenv)
    SRV_Name = server_name(depenv)
  }
  
  stages{
    stage('Build'){
      when { branch comparator: 'REGEXP', pattern: 'Dev'}
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
      when { not {branch comparator: 'REGEXP', pattern: 'Dev'} }
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
                 //scp -o StrictHostKeyChecking=no ${env.WORKSPACE}/*.gz ec2-user@${Remote_ID}:/home/ec2-user/testdir/
            sh """
                 scp -o StrictHostKeyChecking=no ${env.WORKSPACE}/*.gz ec2-user@${SRV_Name}:/home/ec2-user/testdir/
            """
        }
      }
    }
  }
}

def deployevn(depenv){
   script{
      if (  depenv == "master" || depenv == "Master" || depenv == "MASTER" )
      {
           def RemoteID="RemoteMAc"
           return RemoteID
      }
      else if ( depenv == "dev" || depenv == "Dev" || depenv == "DEV" )
      {
           def RemoteID="RemoteID01"
           return RemoteID
      }
    }
}

def server_name(depenv){
	script{
	      if (  depenv == "master" || depenv == "Master" || depenv == "MASTER" )
      	      {
           	def RemoteSRV="172.31.2.140"
           	return RemoteSRV
              }
      	      else if ( depenv == "dev" || depenv == "Dev" || depenv == "DEV" )
      	      {
           	def RemoteSRV="172.31.8.211"
           	return RemoteSRV
      	      }
    	}
}


currentBuild.displayName = "LCADPIP-#"+currentBuild.number

pipeline{
  options { timeout(time: 3, unit: 'MINUTES') }
  //options { timestamps() }
  agent any

  environment {
    //depenv = "${env.JOB_NAME}".split('-').last()
    depenv = deployment()
    Remote_ID = deployevn(depenv)
    SRV_Name = server_name(depenv)
    USR_Name = user_name(depenv)
    buildid = buildID()
    buildEnv01 = buildEnv()
    //buildid = "d56231275a51908867856ea9e8bed0a45c48dbec"
  }
 
  stages{
      stage('Build'){
      when { environment name: 'depenv', value: 'UAT' }
      steps{
           script {
                  sh "chmod +x -R ${env.WORKSPACE}"
                  //sh "${env.WORKSPACE}/../${env.JOB_NAME}@script/script.sh"
                  try {
                    //dir('/home/testenv/'){    
                    sh "sh /home/testenv/one.sh"
                    sh "echo ${env.WORKSPACE}"
	            sh "echo ${REPO_NAME}"
		    sh "echo ${EnvironmentName}"
	            sh "echo ${depenv} testing ${buildid}"
                    sh "/usr/bin/cp /home/testenv/*.* ${env.WORKSPACE}/"
	            sh "/usr/bin/rm -fr *.gz"
		    sh "/usr/bin/gzip -f -S .`date +%Y%m%d`.${depenv}.${env.BUILD_NUMBER}.gz ${env.WORKSPACE}/*.sh"
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
      when { environment name: 'depenv', value: 'UAT' } 
      steps{
        sh "echo \"${env.BUILD_TAG}\""
        sh "echo ${depenv}"
        script {
          buildName = 'LCADPB'
          buildNumber = "${env.BUILD_NUMBER}"
          buildEnvironment = "${depenv}"
	  NEW="TESTENV"
          def server = Artifactory.server "LCADD"
	  def uploadSpec = '{"files": [{"pattern": "*.gz", "target": "LCADDEV/", "props": "version=${buildid};NEW=${TESTENV}"}]}'

          def buildInfo = Artifactory.newBuildInfo()
          buildInfo.name = buildName + '-' + buildEnvironment
          //buildInfo.number = "LCAD_Release_Number"
          server.upload spec: uploadSpec, buildInfo: buildInfo
          server.publishBuildInfo buildInfo
        }
      }
    }

    /*stage('Download - Prod'){
      when { not {environment name: 'depenv', value: 'Dev' }}
      steps{
	script{
              RELEASE_ENV = input message: 'User input required', ok: 'Ok to go?!',
                  parameters: [
                                  choice(name: 'RELEASE_TYPE', choices: 'Artifactory\nClearCaseAndArtifactory\nAbort', description: 'What is the release scope?'),
	       		          string(name: 'VERSION', defaultValue: '${buildid}', description: '''Edit release name please!!''', trim: false)
                              ]
        }
	sh "echo ${depenv}"
	sh "mkdir -p ${WORKSPACE}/Download"
        script {
          buildName = 'LCADPB'
          buildNumber = "${env.BUILD_NUMBER}"
          buildEnvironment = "${depenv}"
          def server = Artifactory.server "JfrogServer"
          def downloadSpec = '{"files": [{"pattern": "LCADPB/", "target": "${WORKSPACE}/Download/",  "props": "version=${buildid}"}]}'

          def buildInfo = server.download(downloadSpec)
          buildInfo.name = buildName + '-' + buildEnvironment
          buildInfo.number = "LCAD_Release_Number"
	  echo "retriving data"
	  //env.LAST_BUILD_NAME=buildInfo.build.number
          //server.download spec: downloadSpec, buildInfo: buildInfo
          //server.publishBuildInfo buildInfo
	  
        }
      }
    }*/
 
    stage('Deploy Files to Remote'){
      //when { not { environment name: 'depenv', value: 'Dev' } }
      steps{
	sh "echo ${depenv}"
	      //script{
	      sshagent(["${Remote_ID}"]) {  
                 //scp -o StrictHostKeyChecking=no ${env.WORKSPACE}/*.gz ec2-user@${Remote_ID}:/home/ec2-user/testdir/
		 //scp -o StrictHostKeyChecking=no -v ${env.WORKSPACE}/*.gz newenv00@${SRV_Name}:/home/newenv00/test00
                 sh """
		 whoami 
		 cd ${env.WORKSPACE}
		 echo ${USR_Name}
		 echo ${SRV_Name}
		 ssh -vvv ${USR_Name}@${SRV_Name} \"/home/newenv01/testdir/downld.sh ${depenv}\"
		 """
		 //ssh ${USR_Name}@${SRV_Name} \"wget --user=admin --password=AP44rK5FLUuFrRt7jKeNrjSShcu \"http://172.31.8.211:8081/artifactory/LCADDEV/two.sh.20201129.${depenv}.${env.BUILD_NUMBER}.gz\"\"
        }
      }
    }
  }
  post {
   success {
        sh "echo SUCESS"
    }
    failure {
        sh "echo FAILURE"
    }
  }
}

def deployment(){
   script{
	   if (env.JOB_BASE_NAME.endsWith('-Dev')){
		   return "Dev"
	   } else if (env.JOB_BASE_NAME.endsWith('-Prod')){
		   return "Master"
	   } else if (env.JOB_BASE_NAME.endsWith('-UAT')){
		   return "UAT"
	   }

   }
}

def deployevn(depenv){
   script{
      if (  depenv == "master" || depenv == "Master" || depenv == "MASTER" )
      {
           def RemoteID="NewServer01"
           return RemoteID
      }
      else if ( depenv == "dev" || depenv == "Dev" || depenv == "DEV" )
      {
           //def RemoteID="NewSever02"
	   def RemoteID="NewSever00"
           return RemoteID
      }
    }
}

def server_name(depenv){
	script{
	      if ( depenv == "dev" || depenv == "Dev" || depenv == "DEV" )
      	      {
           	//return "172.31.2.140|/home/ec2-user/testdir/|RemoteMAc"
           	//return "172.31.42.201"
		return "172.31.42.13"
              }
      	      else if (  depenv == "master" || depenv == "Master" || depenv == "MASTER" )
      	      {
           	//return "172.31.8.211|/home/ec2-user/testdir/|RemoteID01"
           	return "172.31.39.86"
      	      }
	      else if (  depenv == "uat" || depenv == "UAT" || depenv == "Uat" )
      	      {
           	//return "172.31.8.211|/home/ec2-user/testdir/|RemoteID01"
           	return "172.31.42.201"
      	      }
    	}
}

def user_name(depenv){
	script{
	      if ( depenv == "dev" || depenv == "Dev" || depenv == "DEV" )
      	      {
           	//return "172.31.2.140|/home/ec2-user/testdir/|RemoteMAc"
           	//return "172.31.42.201"
		return "newenv01"
              }
      	      else if (  depenv == "master" || depenv == "Master" || depenv == "MASTER" )
      	      {
           	//return "172.31.8.211|/home/ec2-user/testdir/|RemoteID01"
           	return "newenv02"
      	      }
	      else if (  depenv == "uat" || depenv == "Uat" || depenv == "UAT" )
      	      {
           	//return "172.31.8.211|/home/ec2-user/testdir/|RemoteID01"
           	return "newenv01"
      	      }
    	}
}

def buildID(){
    script{
      return sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    }
}

def buildEnv(){
    script{
      return sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
    }
}


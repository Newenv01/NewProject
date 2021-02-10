currentBuild.displayName = "LCADPIP-#"+currentBuild.number

pipeline{
  options { timeout(time: 3, unit: 'MINUTES') }
  //options { timestamps() }
  agent any

  environment {
    //depenv = "${env.JOB_NAME}".split('-').last()
    //depenv = deployment()
    depenv = "$DepEnv"
    Remote_ID = deployevn(depenv)
    SRV_Name = buildInfo(depenv)
    def ServerName = "${SRV_Name.split('\\|')[0]}"
    def RemoteServer = "${SRV_Name.split('\\|')[1]}"
    def RemoteID = "${SRV_Name.split('\\|')[2]}"
    //def BLD_NUM = buildNum(BULD_NUM)
    //def (ServerNames, RmtPath, CredID) = "${SRV_Name}.tokanize("|")"
    USR_Name = user_name(depenv)
    buildid = buildID()
    buildEnv01 = buildEnv()
    //buildid = "d56231275a51908867856ea9e8bed0a45c48dbec"
  }
 
  stages{
      stage('Build'){
      when { anyOf { 
	          environment name: 'depenv', value: 'Dev';
	          environment name: 'depenv', value: 'Dev1'
		}
	   }
      steps{
           script {
                  sh "chmod +x -R ${env.WORKSPACE}"
                  //sh "${env.WORKSPACE}/../${env.JOB_NAME}@script/script.sh "
                  try {
                    //dir('/home/testenv/'){    
                    sh "sh /home/testenv/one.sh"
	            //sh "echo \"${env.WORKSPACE}, ${ServerMames} ${RmtPath}, ${CredID}\""
     		    //sh "echo \"${env.WORKSPACE}, ${RemoteID}, ${ServerName}\""
		    sh "/usr/bin/cp /home/testenv/*.* ${env.WORKSPACE}/"
	            sh "/usr/bin/rm -fr *.gz"
		    //sh "/usr/bin/gzip -f -S .`date +%Y%m%d`.${depenv}.${env.BUILD_NUMBER}.gz ${env.WORKSPACE}/*.sh"
		    sh "/usr/bin/tar -cvzf AppDeploy.`date +%Y%m%d`.${depenv}.${env.BUILD_NUMBER}.gz *.sh*"
                    //sh "/usr/bin/bash /root/test/one.sh"
                    //sh 'pwr=$(pwd); $pwr/script.sh "/test/root/one.sh"'
                    sh "ls -ltr"
                    sh "echo $BUILD_TAG"
		    sh "scp -vvv -o StrictHostKeyChecking=no *.* ${RemoteID}@${ServerName}:/home/newenv01/testdir/newfile/"
		    ZIPFIL = sh(returnStdout: true, script: "ls -1 AppDeploy*.gz").trim()
	            currentBuild.result = "SUCCESS"
                    //}
                  } catch (err) {
                      echo err.getMessage()
		      throw (err)
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
      //when { any { environment name: 'depenv', value: 'Dev' } || { environment name: 'depenv', value: 'Dev1' } }
      when { anyOf { 
	          environment name: 'depenv', value: 'Dev';
	          environment name: 'depenv', value: 'Dev1'
		}
           }
      steps{
        script {
	  try {
	    sh "echo \"${env.BUILD_TAG}\""
            sh "echo ${depenv}"
	    sh "cd ${env.WORKSPACE}"
	    def ZIPFIL= "AppDeploy"
	    sh "echo \"${ZIPFIL} is good example\""
            buildName = 'LCADPB'
            buildNumber = "${env.BUILD_NUMBER}"
            buildEnvironment = "${depenv}"
            def server = Artifactory.server "LCADD"
            def uploadSpec = '{"files": [{"pattern": "*.gz", "target": "LCADDEV/", "props": "FIL=$ZIPFIL"}]}'

            def buildInfo = Artifactory.newBuildInfo()
            buildInfo.name = buildName + '-' + buildEnvironment
            //buildInfo.number = "LCAD_Release_Number"
            server.upload spec: uploadSpec, buildInfo: buildInfo
            currentBuild.result = 'FAILURE'
            sh "exit 0"
	  } catch (err) {
	  server.publishBuildInfo buildInfo
	  throw (err)
          currentBuild.result = 'FAILURE'
	  sh "exit 2"
          }
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
	  script{
	    if ( depenv == "uat" || depenv == "Dev2" || depenv == "Dev" )
	    {
	    sh "echo ${depenv}"
	    sshagent(["${Remote_ID}"]) {  
                sh """
		      whoami
		      echo ${USR_Name}
		      echo ${SRV_Name}
		      echo ${BULD_NUM}
                      ssh -vvv ${RemoteID}@${ServerName} \"ksh -x /home/newenv01/testdir/down.sh ${depenv} ${BULD_NUM} ${BUILD_NUMBER}\"
		 """
	     }
	    } else {
                def ServerName01 = "${SRV_Name.split('\\|')[3]}"
                def RemoteServer01 = "${SRV_Name.split('\\|')[4]}"
                def RemoteID01 = "${SRV_Name.split('\\|')[5]}"
                sshagent(["${Remote_ID}"]) {  
                sh """
		      whoami
		      echo \" ${ServerName} and ${ServerName01}\"
		      echo \"${RemoteServer} and ${RemoteServer01}\"
		      echo \"${RemoteID} and ${RemoteID01}\"
                      ssh -vvv ${RemoteID}@${ServerName} \"ksh -x /home/newenv01/testdir/down.sh ${depenv} ${BULD_NUM}\"
		 """
	        }
	    }	    
	  }
         }
      }
    //}
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
	   } else if (env.JOB_BASE_NAME.endsWith('-DEV1')){
		   return "QA"
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
	   def RemoteID="NewSever00"
           return RemoteID
      }
      else if (  depenv == "uat" || depenv == "UAT" || depenv == "Uat" )
      {
	         def RemoteID="NewSever01"
                 return RemoteID
      }
    }
}

def server_name(depenv){
    script{
        if ( depenv == "dev" || depenv == "Dev" || depenv == "DEV" )
      	{
           	//return "172.31.42.201|/home/newenv01/testdir/|RemoteMAc"
           	//return "172.31.42.13|NewServer01|newenv00"
		return "172.31.42.201"
        }
      	else if (  depenv == "master" || depenv == "Master" || depenv == "MASTER" )
      	{
           	//return "172.31.39.86|/home/ec2-user/testdir/|RemoteID01|newenv02"
		return "172.31.39.86"
      	}
	else if (  depenv == "uat" || depenv == "UAT" || depenv == "Uat" )
      	{
                //return "172.31.42.201|/home/ec2-user/testdir/|RemoteID01|newenv01"
		return "172.31.42.201"
      	}
 	      else if (  depenv == "dev1" || depenv == "Dev1" || depenv == "DEV1" )
      	{
           	//return "172.31.42.201|/home/ec2-user/testdir/|RemoteID01|newenv01"
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
 	      else if (  depenv == "dev1" || depenv == "Dev1" || depenv == "DEV1" )
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

def buildInfo(depenv){
    script{
        if ( depenv == "dev" || depenv == "Dev" || depenv == "DEV" )
      	{
           	return "172.31.42.201|/home/newenv01/testdir/|newenv01|172.31.42.201|/home/newenv00/testdir/|newenv00"
           	//return "172.31.42.13|NewServer01|newenv00"
		//return "172.31.42.201"
        }
      	else if (  depenv == "master" || depenv == "Master" || depenv == "MASTER" )
      	{
           	//return "172.31.39.86|/home/ec2-user/testdir/|RemoteID01|newenv02"
		return "172.31.39.86"
      	}
	else if (  depenv == "uat" || depenv == "UAT" || depenv == "Uat" )
      	{
                //return "172.31.42.201|/home/ec2-user/testdir/|RemoteID01|newenv01"
		//return "172.31.42.201"
		//return "172.31.42.201|/home/newenv01/testdir/|RemoteMAc"
		return "172.31.42.201|/home/newenv01/testdir/|newenv01"
      	}
 	      else if (  depenv == "dev1" || depenv == "Dev1" || depenv == "DEV1" )
      	{
           	//return "172.31.42.201|/home/ec2-user/testdir/|RemoteID01|newenv01"
		return "172.31.42.201"
      	}

    }
}

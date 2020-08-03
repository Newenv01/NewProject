pipeline{
  options { timeout(time: 3, unit: 'MINUTES') }
  //options { timestamps() }
  agent any

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
                    //sh "echo $TAG_NAME"
                    //}
                  } catch (err) {
                      echo err.getMessage()
                      echo "Error detected - BUILD Failure."
                      currentBuild.result = 'FAILURE'
                  }
           } 
       }
    }
    stage('Upload'){
      steps{
        //sh "/usr/bin/curl -u admin:Newenv_01 -X PUT \"http://334.209.82.113:8082/artifactory/LCADPB/\" -T ${env.WORKSPACE}/*.*"
        //sh "/usr/bin/curl -u admin:Newenv_01 -X PUT \"http://34.209.82.113:8082/artifactory/LCADPB/\" -T ${env.WORKSPACE}/*.* -H 'X-Explode-Archive: true'; released=true"
        sh "/usr/bin/curl -H 'X-JFrog-Art-Api:AKCp5fUDwCDnyrHMUnthn1rAKH2uYnNAKbcJXV9Av4ABqGUVdq78fqNghuKCgTs64pfvedBzz' -T ${env.WORKSPACE}/*.* \"http://34.209.82.113:8081/artifactory/LCADPB/\""
        sh "echo testing"
        //rtUpload (
            //serverId: 'JfrogServer',
            //spec: '''{
              //       "files": [
                //         {
                  //        "pattern": "LCADPB/",
                    //      "target": "**/*.gz"
                     //    }
                    // ]
             //}''',
            // Optional - Associate the uploaded files with the following custom build name and build number,
            // as build artifacts.
            // If not set, the files will be associated with the default build name and build number (i.e the
            // the Jenkins job name and number).
            //buildName: 'LCADPB170',
            //buildNumber: '42'
            //"target": "${env.WORKSPACE}/*.gz"
            //insecure-tls: false
            //props: 'type=gz;status=ready',
            //failNoOp: 'true'
         //)
      }
    }
  }
}

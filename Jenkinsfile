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
        rtUpload (
            serverId: 'JfrogServer',
            spec: '''{
                     "files": [
                     {
                          "pattern": "${PROJECT_NAME}/${JOB_NAME}/*lcad*.zip",
                          "target": "LCADPB/"
                     }
                     ]
             }''',
            // Optional - Associate the uploaded files with the following custom build name and build number,
            // as build artifacts.
            // If not set, the files will be associated with the default build name and build number (i.e the
            // the Jenkins job name and number).
            // buildName: 'holyFrog',
            // buildNumber: '42'
         )
      }
    }
  }
}

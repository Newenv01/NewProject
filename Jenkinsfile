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
    stage('Prepration'){
      steps{
           script {
                  sh "chmod +x -R ${env.WORKSPACE}"
                  //sh "${env.WORKSPACE}/../${env.JOB_NAME}@script/script.sh"
                  try {
                    //dir('/root/test/'){    
                    sh('cd /root/test')    
                    sh('/usr/bin/touch one.txt')
                    //sh('./one.sh')
                    //}
                  } catch (err) {
                      echo err.getMessage()
                      echo "Error detected - PREBUILD."
                      currentBuild.result = 'FAILURE'
                  }
           } 
       }
    }
  }
}

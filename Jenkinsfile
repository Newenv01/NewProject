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
                  try {
                        sh "/root/test/one.sh"
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

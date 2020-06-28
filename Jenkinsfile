node{
      stage "SCM Update"
          git url: "https://github.com/Newenv01/NewProject.git"
          sh "mkdir -p output"
          writeFile file: "output/test.txt", text: "This is test file."
          writeFile file: "output/newenve.md", text: "This is also a file"
      stage "Git Build"
          echo "Hellow World"
          archiveArtifacts artifacts: 'output/*.txt', excludes: 'output/*.md'
}

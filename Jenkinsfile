pipeline {
  agent any

  environment {
    NAME = "php-k8s-app"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    IMAGE_REPO = "ashwinbittu"
    //GITHUB_TOK = credentials('GITHUB_TOKEN')
    GITHUB_TOK = "${env.GH_TOKEN}"
  }
  
  stages {
    stage('Unit Tests') {
      steps {
        echo 'Implement unit tests if applicable.'
        echo 'This stage is a sample placeholder'
      }
    }

    stage('Build Image') {
      steps {
            sh "docker build -t ${NAME} ."
            sh "docker tag ${NAME}:latest ${IMAGE_REPO}/${NAME}:${VERSION}"
        }
      }

    stage('Push Image') {
      steps {
        withDockerRegistry([credentialsId: "dockerhub-ashwinbittu", url: ""]) {
          sh 'docker push ${IMAGE_REPO}/${NAME}:${VERSION}'
        }
      }
    }

    stage('Clone/Pull Repo') {
      steps {
        script {
          if (fileExists('k8s-acrogcd')) {

            echo 'Cloned repo already exists - Pulling latest changes'

            dir("k8s-acrogcd") {
              sh 'git pull'
            }

          } else {
            echo 'Repo does not exists - Cloning the repo'
            sh 'git clone -b main https://github.com/ashwinbittu/k8s-acrogcd'
          }
        }
      }
    }
    
    stage('Update Manifest') {
      steps {
        dir("k8s-acrogcd/jenkins-demo") {
          sh 'sed -i "s#ashwinbittu.*#${IMAGE_REPO}/${NAME}:${VERSION}#g" deployment.yaml'
          sh 'cat deployment.yaml'
        }
      }
    }

    stage('Commit & Push') {
      steps {
        dir("k8s-acrogcd/jenkins-demo") {
          sh "git config --global user.email 'jenkins@ci.com'"
          sh 'git remote set-url origin https://$GITHUB_TOK@github.com/ashwinbittu/k8s-acrogcd.git'
          sh 'git checkout'
          sh 'git add -A'
          sh 'git commit -am "Updated image version for Build - $VERSION"'
          sh 'git push origin'
        }
      }
    }

    stage('Raise PR') {
      steps {
        //sh "bash pr.sh"
        sh 'echo "Opening a Pull Request"'
        //sh 'echo $GITHUB_TOK'

        //sh 'echo $GITHUB_TOK | gh auth login --with-token'
        sh 'gh pr create --assignee "@me" --base "main" --title "Updated PHP k8s App" --body "Updated deployment specification with a new image version."'        
        sh 'echo "Success"'        
      }
    } 
  }
}

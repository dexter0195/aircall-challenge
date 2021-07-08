pipeline {
  parameters {
    string(name: 'COMMIT_SHA', defaultValue: '', description: 'Which Commit of you application you want to deploy?')
    choice(name: 'REGION', choices: ['eu-west-1', 'eu-west-2', 'eu-central-1'], description: 'Choose the aws region where you want your service to be deployed')
  }
  agent {
    kubernetes {
      yamlFile 'KubernetesPod.yaml'
    }
  }
  stage('Build') {
    agent {
      kubernetes {
        yamlFile 'KubernetesPod.yaml'
      }
    }
    environment {
      COMMIT_SHA = ${params.COMMIT_SHA}
    }
    steps {
      container(name: 'node') {
        sh './build/build.sh'
      }
    }
  }
  stage('Deploy') {
    agent {
      kubernetes {
        yamlFile 'KubernetesPod.yaml'
      }
    }
    environment {
      AWS_DEFAULT_REGION = ${params.REGION}
    }
    steps {
      withCredentials([usernamePassword(credentialsId:"AWS_DEPLOY_CREDENTIALS", usernameVariable: "AWS_ACCESS_KEY_ID", passwordVariable: "AWS_SECRET_ACCESS_KEY")]){
        container(name: 'terraform') {
          sh './deployment/deploy.sh -a plan -r $REGION -s ./src.zip'

          input(message: "Do you want to apply the previous plan?")

          sh './deployment/deploy.sh -a apply -r $REGION -s ./src.zip'
        }
      }
    }
  }
  post {
    failure {
      slackSend("Something went wrong...")
    }
    success {
      slackSend("hey, your build succeeded!! Hurray!!")
    }
  }
}

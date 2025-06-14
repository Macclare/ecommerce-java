pipeline {
  agent any

  environment {
    IMAGE_NAME = 'macclare/ecommerce-backend'
  }

  stages {
    stage('Clone') {
      steps {
        git branch: 'main', url: 'https://github.com/Macclare/ecommerce-java.git'
      }
    }

    stage('Build') {
      steps {
        dir('backend') {
          sh 'mvn clean package -DskipTests'
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          dir('backend') {
            sh """
              docker login -u $USERNAME -p $PASSWORD
              docker build -t $IMAGE_NAME:latest .
              docker push $IMAGE_NAME:latest
            """
          }
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        withCredentials([
        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds-id']
        ]) {
        sh '''
            aws eks update-kubeconfig --name ecommerce-cluster --region eu-north-1
            kubectl apply -f k8s/deployment.yaml --validate=false
            kubectl apply -f k8s/service.yaml
        '''
        }
      }
    }

  }
}

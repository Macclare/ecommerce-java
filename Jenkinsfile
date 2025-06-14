pipeline {
  agent any

  environment {
    IMAGE_NAME = 'macclare/ecommerce-api'
  }

  stages {
    stage('Clone') {
      steps {
        git 'https://github.com/macclare/ecommerce-backend.git'
      }
    }

    stage('Build') {
      steps {
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh """
            docker login -u $USERNAME -p $PASSWORD
            docker build -t $IMAGE_NAME:latest .
            docker push $IMAGE_NAME:latest
          """
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh """
          aws eks update-kubeconfig --name ecommerce-cluster --region eu-north-1
          kubectl apply -f k8s/deployment.yaml
          kubectl apply -f k8s/service.yaml
        """
      }
    }
  }
}

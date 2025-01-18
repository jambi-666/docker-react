pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'anjush/docker-react'
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_EB_APP_NAME = 'frontend'
        AWS_EB_ENV_NAME = 'Frontend-env'
        AWS_S3_BUCKET = 'elasticbeanstalk-ap-south-1-954976301189'
        AWS_S3_BUCKET_PATH = 'frontend'
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE} -f Dockerfile.dev ."
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    bat "docker run -e CI=true ${DOCKER_IMAGE} npm run test"
                }
            }
        }
        
        stage('Deploy to AWS') {
            when {
                branch 'main'
            }
            environment {
                AWS_CREDENTIALS = credentials('aws-credentials')
            }
            steps {
                script {
                    // Check if EB CLI exists and install if needed
                    bat """
                        where eb > nul 2>&1 || (
                            python -m pip install --upgrade pip
                            pip install awsebcli --upgrade
                        )
                    """
                    
                    // Configure AWS credentials
                    withAWS(credentials: 'aws-credentials', region: "${AWS_DEFAULT_REGION}") {
                        // Deploy to Elastic Beanstalk
                        bat """
                            eb init ${AWS_EB_APP_NAME} --region ${AWS_DEFAULT_REGION} --platform docker
                            eb deploy ${AWS_EB_ENV_NAME}
                        """
                    }
                }
            }
        }
    }
}
pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'anjush/docker-react'
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_EB_APP_NAME = 'frontend'
        AWS_EB_ENV_NAME = 'Frontend-env'
        AWS_S3_BUCKET = 'elasticbeanstalk-ap-south-1-954976301189'
        AWS_S3_BUCKET_PATH = 's3://elasticbeanstalk-ap-south-1-954976301189/'
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}", "-f Dockerfile.dev .")
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}").inside {
                        sh 'CI=true npm run test'
                    }
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
                    // Install AWS EB CLI if not already installed
                    sh '''
                        if ! command -v eb &> /dev/null; then
                            pip install awsebcli --upgrade --user
                        fi
                    '''
                    
                    // Configure AWS credentials
                    withAWS(credentials: 'aws-credentials', region: "${AWS_DEFAULT_REGION}") {
                        // Deploy to Elastic Beanstalk
                        sh """
                            eb init ${AWS_EB_APP_NAME} --region ${AWS_DEFAULT_REGION} --platform docker
                            eb deploy ${AWS_EB_ENV_NAME}
                        """
                    }
                }
            }
        }
    }
}
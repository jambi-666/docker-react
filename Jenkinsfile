pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'anjush/docker-react'
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_EB_APP_NAME = 'docker'
        AWS_EB_ENV_NAME = 'docker-env'
        AWS_S3_BUCKET = 'elasticbeanstalk-us-east-1-923445559289'
        AWS_S3_BUCKET_PATH = 'docker'
        // Use Jenkins credentials
        AWS_ACCESS_KEY_ID = credentials('aws-credentials').ACCESS_KEY_ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials').SECRET_ACCESS_KEY
    }
    
    stages {
        stage('Test') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE}-test -f Dockerfile.dev ."
                    bat "docker run -e CI=true ${DOCKER_IMAGE}-test npm run test"
                }
            }
        }
        
        stage('Build Production Image') {
            steps {
                script {
                    // Build using production Dockerfile
                    bat "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Deploy to AWS') {
            steps {
                script {
                    // Install AWS CLI if not present
                    bat """
                        where aws > nul 2>&1 || (
                            python -m pip install --upgrade pip
                            pip install awscli --upgrade
                        )
                    """
                    
                    // Install EB CLI if not present
                    bat """
                        where eb > nul 2>&1 || (
                            python -m pip install --upgrade pip
                            pip install awsebcli --upgrade
                        )
                    """
                    
                    // Deploy using EB CLI
                    bat """
                        aws configure set aws_access_key_id %AWS_ACCESS_KEY_ID%
                        aws configure set aws_secret_access_key %AWS_SECRET_ACCESS_KEY%
                        aws configure set default.region ${AWS_DEFAULT_REGION}
                        
                        eb init ${AWS_EB_APP_NAME} --region ${AWS_DEFAULT_REGION} --platform docker
                        eb deploy ${AWS_EB_ENV_NAME}
                    """
                }
            }
        }
    }
}
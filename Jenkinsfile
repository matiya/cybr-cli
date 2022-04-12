pipeline {
    agent any

    tools {
        go 'go-1.17'
    }

    environment {
        AWS_REGION = 'us-east-1'
        GO114MODULE = 'on'
        CGO_ENABLED = 0
        GOPATH = "${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_ID}"
    }

    stages {
        stage('Checkout repository') {
            steps {
                cleanWs()
                checkout scm
            }
        }
        stage('Go Vet') {
            steps {
                sh 'go version'
                sh 'go vet'
            }
        }
        stage('Go Test') {
            steps {
                withCredentials([
                    conjurSecretCredential(credentialsId: 'ci-jenkins-cybr-cli-pas-hostname', variable: 'PAS_HOSTNAME'),
                    conjurSecretCredential(credentialsId: 'ci-jenkins-cybr-cli-pas-username', variable: 'PAS_USERNAME'),
                    conjurSecretCredential(credentialsId: 'ci-jenkins-cybr-cli-pas-password', variable: 'PAS_PASSWORD'),
                    conjurSecretCredential(credentialsId: 'ci-jenkins-cybr-cli-ccp-client_cert', variable: 'CCP_CLIENT_CERT'),
                    conjurSecretCredential(credentialsId: 'ci-jenkins-cybr-cli-ccp-client_key ', variable: 'CCP_CLIENT_PRIVATE_KEY')
                ]) {
                    sh '''
                        set +x
                        CCP_CLIENT_CERT=$(echo $CCP_CLIENT_CERT | base64 --decode)
                        CCP_CLIENT_PRIVATE_KEY=$(echo $CCP_CLIENT_PRIVATE_KEY | base64 --decode)
                        set -x
                        go test -v ./pkg/cybr/api
                    '''
                }
            }
            
        }
        stage('Go Build') {
            steps {
                sh '''
                    GOOS=linux GOARCH=amd64 go build -o ./debian/usr/local/bin/cybr .
                    chmod +x ./debian/usr/local/bin/cybr
                '''
            }
        }
        stage('Build Debian Package for apt') {
            steps {
                sh '''
                    dpkg -b ./debian ./debian
                    ls ./debian | grep cybr-cli > pkg_name
                '''
            }
        }
        stage('Release to Nexus apt-hosted') {
            steps {
                withCredentials([
                    conjurSecretCredential(credentialsId: 'cd-nexus-cybr-cli-apt-hosted-username', variable: 'NEXUS_USERNAME'),
                    conjurSecretCredential(credentialsId: 'cd-nexus-cybr-cli-apt-hosted-username', variable: 'NEXUS_PASSWORD')
                ]) {
                    sh 'curl -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" -H "Content-Type: multipart/form-data" --data-binary "@./debian/$(cat pkg_name)" "http://nexus.cybr.rocks:8081/repository/apt-hosted/"'
                }
            }
        }
    }
}

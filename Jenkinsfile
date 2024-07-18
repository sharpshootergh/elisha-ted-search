pipeline{
    agent any
    tools {
        maven "MAVEN"
        jdk "JAVA_HOME8"
        terraform "Terraform"
    }
    options{
        timestamps()
        timeout(unit: "MINUTES", time: 15)
        gitLabConnection('cicd_cowsay')
    }
    triggers{
		gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType: 'All')
	}
    environment{
        VERSION=""
    }
    stages{
         // CHECKOUT STAGE
        stage("Checkout"){
            steps{
                echo "************************************"
                echo "========  CHECKOUT (scm)   ========="
                echo "************************************"
                checkout scm
            }
            post{
                success{
                    echo "========Checkout executed successfully========"
                    script{
                        VERSION=sh( script: 'grep -oPm2 "(?<=<tag>)[^<]+" "pom.xml" | tail -1', returnStdout: true ).trim()  
                        echo "#####################"
                    }
                }
                failure{
                    echo "========Checkout execution failed========"
                }
            }
        }
        stage("Build,Test & Package"){
           steps{
                script{
                    withMaven(maven: "MAVEN", jdk: "JAVA_HOME8"){
                        sh"""mvn -Dmaven.test.skip=true package dockerfile:build"""
                    }
                }
            }
        }

        stage("End2End Test"){
            when { changelog  '.*#test.*' }
            steps{
                script{

                    echo "############################################"
                    echo "############  END TO END TEST ##############"
                    echo "############################################"

                    sh"""
                        ls -la
                        docker compose  -f docker-compose-test.yml  up -d
                        sleep 20
                        python3 e2etest.py
                    """
                }

            }
            post{
                
                always{
                    script{
                        sh"docker compose down"
                    }
                    
                }
            }
        }
        stage("Publish"){
            steps{
                script{
                    sh"""
                        aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.us-west-2.amazonaws.com
                        docker tag embedash:"${VERSION}" 644435390668.dkr.ecr.us-west-2.amazonaws.com/ofori-search-ted-search:"${VERSION}"
                        docker push 644435390668.dkr.ecr.us-west-2.amazonaws.com/ofori-search-ted-search:"${VERSION}"

                    """
                }

            }
        }
        stage("Deploy"){
            steps{ 
                echo "#################################################################"
                echo "***************** DEPLOYMENT STARTS NOW ************************"
                echo "################################################################"
                script{
                    env.COMMIT_ID = env.GIT_COMMIT
                    println(env.COMMIT_ID)
                    WORKSPACE_NAME=sh( script: "git --no-pager show -s --format='%an <%ae>' ${env.COMMIT_ID} | awk '{print \$1\"_\"\$2}'", returnStdout: true).trim()

                                                                                                                            
                    sh """
                        cd infrustructure/
                        terraform init 
                        terraform workspace select "${WORKSPACE_NAME}" || terraform workspace new "${WORKSPACE_NAME}"
                        terraform destroy -var-file=dev.tfvars --auto-approve
                        terraform validate
                        terraform apply -var-file=dev.tfvars --auto-approve
                    """
                }
            }
        }
    }

    post{
        always{
            script{
                sh"docker compose down"
                cleanWs()
            }
        }
    }

}
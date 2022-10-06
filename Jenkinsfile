pipeline{
	agent any
	environment{
	    ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
	    DOCKER_ACCESS_TOKEN = credentials('docker-access-token')
	}
	tools {
            maven 'Maven'
    	}
	
	stages{
	    stage('Fetch code from GitHub'){
	  	agent {
	   	   label 'agent-1'
		}
		steps{
		   git url: "https://github.com/BharadwajAyinapurapu/Spring-Boot-Thymeleaf.git"
		}
	    }
		
	    stage('Compile and Test'){
	  	agent {
	      	   label 'agent-1'
	      	}
	  	steps{
		   sh 'mvn clean test'
	  	}
	    }
		
	    stage('Package'){
		agent {
		   label 'agent-1'
		}
    	  	steps{
    		   sh 'mvn install'
    	     	}
    	  	post{
        	    success{
           		archiveArtifacts 'target/*.war'
           		sh 'java -version'
           		sh 'mvn -version'
           		stash 'source'
    		    }
               }
	    }
		
	    stage('Code Quality Check'){
		agent{
		   label 'agent-1'
		}
		steps{
	    	    withSonarQubeEnv(installationName: 'sonarqube-7.1'){
			 sh 'mvn sonar:sonar \
			 -Dsonar.projectKey=spring	 \
			 -Dsonar.projectName=spring \
			 -Dsonar.host.url=http://20.244.33.251:9000 \
			 -Dsonar.login=9fe0b448d589e6dde9f405e50ed8448f012f09f5'
		    }   
		}
	    }   
	    
	    stage('Custom Quality Gate Check'){
	        agent{
	            label 'agent-1'
	        }
	        steps{
	            waitForQualityGate abortPipeline: true
	        }
	    }
        
	    stage('Publish to JFrog'){
	       agent {
		      label 'agent-1'
	       }
 	       steps{
 		   sh 'jf rt ping --url http://20.244.50.64:8082/artifactory/'
 		   sh 'jf rt u --url http://20.244.50.64:8082/artifactory/ --access-token ${ARTIFACTORY_ACCESS_TOKEN} target/spring-boot-thymeleaf-2.0.0.war Spring-Boot-Thymeleaf/'
 	       }	
 	    }
	    
		
   	    stage('Tomcat deploy'){
		agent {
		   label 'agent-1'
		}
		steps{
		   //ansiblePlaybook becomeUser: 'bd', credentialsId: 'SSH-Private-key', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'playbook.yml'
		
    		   	sh 'ansible all -m ping'
    	       		sh 'ansible-playbook installation.yml'
               		//sh 'ansible-playbook playbook.yml'
               		sh 'ansible-playbook deployment.yml'
		}
	    }		

            stage('Docker Stage'){
 	        agent {
		      label 'agent-1'
		    }
 	        steps{
 	            sh ' docker build -t bharadwajayinapurapu/spring-boot-thymeleaf:V.$BUILD_NUMBER .'
 	            sh ' echo $DOCKER_ACCESS_TOKEN_PSW | docker login --username $DOCKER_ACCESS_TOKEN_USR --password-stdin'
 	            sh ' docker push bharadwajayinapurapu/spring-boot-thymeleaf:V.$BUILD_NUMBER'
 	        }
 	        
 	    }
		
	    stage('K8S deploy'){
	        agent{
		   label 'agent-2'
	    	}
	        steps{
		    unstash 'source'
		    //sh 'kubectl delete deployment myapp-deployment'
	            //sh 'kubectl delete service myapp-service'
	            sh 'echo $BUILD_NUMBER'
	            sh 'chmod +x changeTag.sh'
	            sh './changeTag.sh V.$BUILD_NUMBER'
		    sh 'kubectl apply -f YAML.yml'
	            sh 'kubectl get deployment'
	            sh 'kubectl get svc'
		    /*script{
		        kubernetesDeploy(
			     configs: 'YAML.yml',
			     kubeconfigId: 'K8S' 
			)
		    }*/
	        }
	    }
		
	    
	}
	
	post{	
	    always{
	        sh 'docker logout'
	    }
	}
}

pipeline{
	agent any
	
	stages{
		stage('Fetch code from GitHub'){
		  steps{
		  	git url: "https://github.com/BharadwajAyinapurapu/Spring-Boot-Thymeleaf.git"
		  }
		}
		
		stage('Compile and Test'){
		  steps{
		  	sh 'mvn clean test'
		  }
		}
		
		stage('Package'){
            steps{
            	sh 'mvn install'
            }
            post{
                success{
                   	archiveArtifacts 'target/*.war'
            	}
            }
		}
		
		stage('Tomcat deploy'){
		    steps{
		        ansiblePlaybook credentialsId: 'Tomcat-deploy', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'playbook.yml'    
		    }
		}
		
	}
}

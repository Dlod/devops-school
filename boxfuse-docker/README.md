boxfuse-sample-java-war-hello
=============================

Boxfuse Sample Hello World Java application packaged as a war file in docker

## Running

1. git clone https://github.com/Dlod/devops-school.git
2. cd devops-school/boxfuse-docker
3. docker build -t boxfuse .
4. docker run -d --rm --name boxfuse -p 8080:8080 boxfuse

Done!

Open your browser at http://localhost:8080/hello/

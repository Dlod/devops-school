FROM ubuntu:20.04
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
	apt update&& apt install unzip default-jdk git maven wget -y && \
	cd /root && git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git boxfuse && \
	cd boxfuse && mvn package && \
	mv /root/boxfuse/target/*.war /opt/hello.war 

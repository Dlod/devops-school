FROM ubuntu:18.04
ADD app/requirements.txt /tmp/
ADD app/* /opt/webapp/
RUN apt update&& DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-all python-pip
RUN pip install -r /tmp/requirements.txt
WORKDIR /opt/webapp/
EXPOSE 5000
CMD ["python", "app.py"]
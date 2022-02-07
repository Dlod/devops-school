FROM ubuntu:14.04
ADD app/requirements.txt /tmp/
ADD app/* /opt/webapp/
RUN apt update&& DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-all python-pip
RUN pip -qr /tmp/requirements.txt
EXPOSE 5000
CMD ["python", "app.py", "--port", "5000"]
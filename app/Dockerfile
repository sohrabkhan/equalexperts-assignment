FROM python:3.9
MAINTAINER Sohrab Khan "sohrab@sohrabkhan.com"
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["uwsgi"]
CMD ["--ini", "uwsgi.ini"]

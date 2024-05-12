FROM nginx:latest

RUN apt update && apt install -y python3-full

WORKDIR /flaskapp

RUN python3 -m venv /flaskapp/venv

COPY requirements.txt /flaskapp/requirements.txt

RUN /flaskapp/venv/bin/pip install -r requirements.txt

COPY app.py /flaskapp/app.py

COPY site.conf /etc/nginx/sites-available/flaskapp.conf
RUN ln -s /etc/nginx/sites-available/flaskapp.conf /etc/nginx/conf.d/flaskapp.conf
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

COPY start.sh /flaskapp/start.sh
RUN chmod +x /flaskapp/start.sh
ENTRYPOINT ["/bin/bash", "/flaskapp/start.sh"]

# Python 3.8 슬림 버전을 기반 이미지로 사용
FROM python:3.8-slim

# Nginx 설치
RUN apt-get update && apt-get install -y nginx

# 작업 디렉토리 설정
WORKDIR /flaskapp

# Python 가상 환경 설정
RUN python3 -m venv /flaskapp/venv

# 필요한 Python 패키지 설치
COPY requirements.txt /flaskapp/
RUN /flaskapp/venv/bin/pip install -r requirements.txt

# 애플리케이션 코드 복사
COPY app.py /flaskapp/

# Nginx 설정 파일 복사 및 기본 설정 제거
COPY site.conf /etc/nginx/sites-available/flaskapp.conf
RUN ln -s /etc/nginx/sites-available/flaskapp.conf /etc/nginx/sites-enabled/ && \
    rm /etc/nginx/sites-enabled/default

# 시작 스크립트 복사 및 실행 권한 부여
COPY start.sh /flaskapp/
RUN chmod +x /flaskapp/start.sh

# 컨테이너 시작 시 실행할 스크립트 지정
ENTRYPOINT ["/bin/bash", "/flaskapp/start.sh"]

# Nginx를 포그라운드 모드로 실행
CMD ["nginx", "-g", "daemon off;"]

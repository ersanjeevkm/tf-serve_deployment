FROM python:3.8.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ["gateway.py", "./"]

EXPOSE 5555
ENTRYPOINT [ "gunicorn", "--bind=0.0.0.0:5555", "gateway:app" ]
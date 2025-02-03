FROM python:3.9

# This makes output not buffer and return immediately, nice for seeing results in stdout
ENV PYTHONUNBUFFERED=1

RUN mkdir -p /app

# Install Docker
RUN apt-get update && curl -fsSL https://get.docker.com | sh

WORKDIR /app


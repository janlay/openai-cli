FROM ubuntu:latest
LABEL Name=openaicli Version=0.0.1
RUN apt-get -y update && apt-get install -y jq curl
COPY openai /openai
RUN chmod +x /openai
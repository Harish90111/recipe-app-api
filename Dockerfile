#FROM defines base image.
#python:3.9-alpine3.13 = Python 3.9 + Alpine Linux.
#Alpine → lightweight Linux optimized for containers.
#Smaller images improve deployment and CI/CD efficiency. */
FROM python:3.9-alpine3.13


LABEL key="harishsarwarsingh"

#Python on buffered space = 1.
#And this is recommended when you are running Python in a Docker container.
#What it does, it tells Python that you don't want to buffer the output.
#The output from Python will be printed directly to the console, 
#which prevents any delays of messages getting from our Python running application 
#to the screen so we can see the logs immediately in the screen as they're running.
ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user




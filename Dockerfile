FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

# Python input will be run in the console
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Default value false for DEV argument
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # Install dev requirements
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # remove tmp files because we installed everything
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        # Random username
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user
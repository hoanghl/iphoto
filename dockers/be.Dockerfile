FROM python:3.10

ENV PIPENV_VENV_IN_PROJECT=0
ENV PIPENV_IGNORE_VIRTUALENVS=1

WORKDIR /code

COPY Pipfile .

RUN pip install pipenv

RUN pipenv install --deploy

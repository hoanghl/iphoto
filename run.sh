export $(cat .env | xargs)
# pipenv shell
pipenv run fastapi run main.py

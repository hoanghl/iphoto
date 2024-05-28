export $(cat .env | xargs)
fastapi run main.py --port 30556

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from src import routes

app = FastAPI()

app.include_router(routes.router)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

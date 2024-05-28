import os

from loguru import logger

USER = os.getenv("USER", None)
PWD = os.getenv("PASSWORD", None)
HOST = os.getenv("HOST", None)
PORT = os.getenv("PORT", None)
DBNAME = os.getenv("DBNAME", None)
TBLNAME = os.getenv("TBLNAME", None)

PATH_DIR_RES = os.getenv("PATH_DIR_RES", None)

env_vars = {
    "USER": USER,
    "PWD": PWD,
    "HOST": HOST,
    "PORT": PORT,
    "DBNAME": DBNAME,
    "TBLNAME": TBLNAME,
    "PATH_DIR_RES": PATH_DIR_RES,
}

for name, env_var in env_vars.items():
    if env_var is None:
        logger.error(f"Env var not set: {name}")

        exit(1)

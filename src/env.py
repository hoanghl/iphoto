import os

from loguru import logger

USER = os.getenv("DB_INFO_USER", None)
PWD = os.getenv("DB_INFO_PWD", None)
HOST = os.getenv("DB_INFO_HOST", None)
PORT = os.getenv("DB_INFO_PORT", None)
DBNAME = os.getenv("DB_INFO_DB", None)
TBLNAME = os.getenv("DB_INFO_TBLNAME", None)

PATH_DIR_RES = os.getenv("DB_FILE_DIR", None)

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

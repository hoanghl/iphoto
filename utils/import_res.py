import argparse
from datetime import datetime as dt
from pathlib import Path

import psycopg as pg
from psycopg import sql

USER = "evil"
PASSWORD = "qwe"
HOST = "192.168.0.193"
PORT = 5432
DB = "eviltrans"


def log(s: str):
    print(s)


def connect(func):
    def inner1(*args, **kwargs):
        try:
            with pg.connect(
                user=USER,
                password=PASSWORD,
                host=HOST,
                port=PORT,
                dbname=DB,
            ) as conn:
                with conn.cursor() as cur:
                    return func(cur=cur, conn=conn, *args, **kwargs)

        except pg.OperationalError as e:
            print("error: ", e)

            return None

    return inner1


@connect
def send(res_type: str, filenames: list[str], table_name: str = "resources", **kwargs):
    cur = kwargs["cur"]
    conn = kwargs["conn"]

    values = [(res_type, name, None, dt.now()) for name in filenames]

    stmt = sql.SQL("""
        insert into {table} 
        (res_type, file_name, thumbnail_name, last_update) 
        values ({placeholders})
        ;
    """).format(
        table=sql.Identifier(table_name),
        placeholders=sql.SQL(", ").join(sql.Placeholder() * len(values[0])),
    )
    cur.executemany(stmt, values)
    # cur.execute(stmt)
    conn.commit()


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("path")
    parser.add_argument("res_type")

    args = parser.parse_args()

    return args


if __name__ == "__main__":
    args = parse_args()

    log("1. Read file")

    path = Path(args.path)
    if not path.is_dir():
        log(f"Path specified not directory: {path}")
        exit(1)
    if not path.exists():
        log(f"Path specified not existed: {path}")
        exit(1)

    filepaths = list(path.glob("*"))
    if len(filepaths) == 0:
        log("Not found any file inside specified path")
        exit(1)

    filenames = [path.name for path in filepaths]

    log("2. Send to DB")
    res_type = args.res_type

    send("image", filenames)

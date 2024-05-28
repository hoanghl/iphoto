import psycopg as pg
from loguru import logger
from psycopg import sql

from src import env


def connect(func):
    def inner1(*args, **kwargs):
        try:
            with pg.connect(
                user=env.USER,
                password=env.PWD,
                host=env.HOST,
                port=env.PORT,
                dbname=env.DBNAME,
            ) as conn:
                with conn.cursor() as cur:
                    return func(cur=cur, conn=conn, *args, **kwargs)

        except pg.OperationalError as e:
            logger.error(f"Connect to DB got error: {e}")

            return None

    return inner1


@connect
def get_ids(res_type: str, **kwargs) -> list | None:
    """Get list of ids

    Args:
        res_type (str): resource type

    Returns:
        list | None: list of ids or None if error occurs
    """

    assert env.TBLNAME

    cur = kwargs["cur"]

    stmt = sql.SQL("""
        select
            id
        from
            {table}
        where 1=1
            and res_type = {res_type}
        ;""").format(
        table=sql.Identifier(env.TBLNAME),
        res_type=sql.Literal(res_type),
    )
    cur.execute(stmt)

    ret = cur.fetchall()

    ret = [x[0] for x in ret]

    return ret


@connect
def get_res_list_info(ids: list[int], res_type: str, **kwargs) -> list | None:
    """Get list of resources' info

    Args:
        ids (list[int]): resource ID list
        res_type (str): resource type

    Returns:
        list | None: list of info or None if error occurs
    """
    assert env.TBLNAME

    cur = kwargs["cur"]

    # Query db
    stmt = sql.SQL("""
        select 
            T1.id				
            , T1.file_name		
            , T1.res_type		
            , T2.id 			as thumbnail_id
            , T1.thumbnail_name
        from
            {table} T1
        LEFT JOIN {table} T2 ON 1=1
            AND T2.res_type = 'thumbnail'
            AND T2.file_name = T1.thumbnail_name
        where 1=1
            and T1.res_type = {res_type}
            and T1.id = ANY({ids})
        ;""").format(
        table=sql.Identifier(env.TBLNAME),
        res_type=sql.Literal(res_type),
        ids=sql.Literal(ids),
    )
    cur.execute(stmt)

    entries = cur.fetchall()

    # Process output from db query
    ret = []

    for entry in entries:
        ret.append(
            {
                "id": entry[0],
                "name": entry[1],
                "res_type": entry[2],
                "thumbnail": {"id": entry[3], "name": entry[4]},
            }
        )

    return ret


@connect
def get_res_info(res_id: str, **kwargs) -> dict | None:
    """Get resource info

    Args:
        res_id (str): res_id of resource

    Returns:
        dict|None: resource info or None if error
    """

    # Get info from DB
    assert env.TBLNAME

    cur = kwargs["cur"]

    stmt = sql.SQL("""
        select
            res_type, file_name
        from
            {table}
        where 1=1
            and id = {res_id}
    ;""").format(
        table=sql.Identifier(env.TBLNAME),
        res_id=sql.Literal(res_id),
    )
    cur.execute(stmt)
    result = cur.fetchone()

    if result is None or len(result) == 0:
        return {}

    return {
        "res_type": result[0],
        "res_name": result[1],
    }

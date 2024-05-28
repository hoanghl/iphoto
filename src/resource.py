from pathlib import Path

from loguru import logger

from src import env

VALID_RES_TYPES = ["image", "video", "thumbnail"]


def _gen_path(res_name: str, res_type: str) -> Path | None:
    """Generate resource path from resource name and type

    Args:
        res_name (str): resource name
        res_type (str): resource type

    Returns:
        Path|None: path if it exists, None otherwise
    """
    assert env.PATH_DIR_RES

    path = Path(env.PATH_DIR_RES) / res_type / res_name
    if not path.exists():
        return None

    return path


def get_resource(res_name: str, res_type: str) -> bytes | None:
    """Read resource from disk

    Args:
        res_name (str): resource name
        res_type (str): resource type

    Returns:
        bytes|None: data if path exists, None otherwise
    """
    assert res_type in VALID_RES_TYPES, logger.error(f"Invalid res_type: {res_type}")

    path_res = _gen_path(res_name, res_type)
    if path_res is None:
        return None

    with open(path_res, "rb") as f:
        resource = f.read()

    return resource

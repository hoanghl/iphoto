from pathlib import Path

from src import env

VALID_RES_TYPES = ["image", "video", "thumbnail"]


def _gen_path(res_name: str, res_type: str) -> Path:
    """Generate resource path from resource name and type

    Args:
        res_name (str): resource name
        res_type (str): resource type

    Returns:
        Path|None: path if it exists, None otherwise
    """
    assert env.PATH_DIR_RES

    path = Path(env.PATH_DIR_RES) / res_type / res_name

    return path


def get_resource(res_name: str, res_type: str) -> bytes | None:
    """Read resource from disk

    Args:
        res_name (str): resource name
        res_type (str): resource type

    Returns:
        bytes|None: data if path exists, None otherwise
    """
    assert res_type in VALID_RES_TYPES, "Invalid res_type: {res_type}"

    path_res = _gen_path(res_name, res_type)
    if not path_res.exists():
        raise AssertionError(f"Invalid path_res: {path_res}")

    with open(path_res, "rb") as f:
        resource = f.read()

    return resource


def store_resource(res_name: str, res_type: str, contents: bytes):
    """Store resource to disk

    Args:
        res_name (str): resource name
        res_type (str): resource type
        contents (bytes): upload resource
    """

    path_res = _gen_path(res_name, res_type)
    if path_res.exists():
        raise AssertionError(f"Existed resource path: {path_res}")

    with open(path_res, "wb") as file:
        file.write(contents)

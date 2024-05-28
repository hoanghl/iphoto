import random
import traceback

from fastapi import APIRouter, HTTPException, Response
from loguru import logger

from src import db, resource

router = APIRouter()
VALID_RES_TYPES = ["image", "video"]


@router.get("/res/")
async def get_res_list_info(res_type: str, quantity: int):
    try:
        assert res_type in VALID_RES_TYPES

        # Get ids of resources with res_type
        ids = db.get_ids(res_type)
        if ids is None:
            raise HTTPException(status_code=500, detail="Cannot connect to DB")

        # Sample ids
        ids_sampled = random.sample(ids, quantity)

        # Get resource with corresponding id and resource type
        out = db.get_res_list_info(ids_sampled, res_type)
        if out is None:
            raise HTTPException(status_code=500, detail="Cannot connect to DB")
        elif out == []:
            raise HTTPException(status_code=500, detail="Cannot fetch data from DB")

        return out
    except HTTPException as e:
        logger.error(traceback.format_exc())
        return e
    except Exception:
        logger.error(traceback.format_exc())
        raise HTTPException(status_code=500)


@router.get("/res/{res_id}/")
async def get_res_info(res_id: str):
    try:
        info = db.get_res_info(res_id)
        if info == {}:
            raise HTTPException(status_code=404, detail="Resource not found")
        elif info is None:
            raise HTTPException(status_code=500, detail="Cannot connect to DB")

        # Get resource in binary stored in disk
        out = resource.get_resource(info["res_name"], info["res_type"])
        if info["res_type"] == "image":
            media_type = "image/png"
        elif info["res_type"] == "video":
            media_type = "video/mp4"
        else:
            raise NotImplementedError()

        return Response(content=out, media_type=media_type)
    except HTTPException as e:
        logger.error(traceback.format_exc())
        return e
    except Exception:
        logger.error(traceback.format_exc())
        raise HTTPException(status_code=500)


@router.post("/res")
async def upload_res():
    # TODO: HoangLe [May-20]: Implement this
    pass

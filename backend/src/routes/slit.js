python
"""
FastAPI router for CRUD operations on "slit" resources.

Endpoints:
- POST   /slits      : create a new slit
- GET    /slits      : list slits (paginated)
- GET    /slits/{id} : retrieve a single slit
- PATCH  /slits/{id} : partially update a slit
- DELETE /slits/{id} : delete a slit

All endpoints return JSON responses with appropriate HTTP status codes.
"""

from __future__ import annotations

import logging
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel, Field, validator
from sqlalchemy import Column, Integer, String, Text, delete, select, update
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import declarative_base

# --------------------------------------------------------------------------- #
# Logging configuration
# --------------------------------------------------------------------------- #
logger = logging.getLogger(__name__)
if not logger.handlers:
    handler = logging.StreamHandler()
    formatter = logging.Formatter(
        fmt="%(asctime)s %(levelname)s %(name)s %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)

# --------------------------------------------------------------------------- #
# SQLAlchemy model definition
# --------------------------------------------------------------------------- #
Base = declarative_base()


class Slit(Base):
    """SQLAlchemy model representing a slit."""

    __tablename__ = "slits"

    id: int = Column(Integer, primary_key=True, index=True, autoincrement=True)
    name: str = Column(String(255), nullable=False, unique=True, index=True)
    description: Optional[str] = Column(Text, nullable=True)
    material: str = Column(String(100), nullable=False)

    def __repr__(self) -> str:
        return f"<Slit id={self.id} name={self.name!r}>"


# --------------------------------------------------------------------------- #
# Pydantic schemas
# --------------------------------------------------------------------------- #
class SlitBase(BaseModel):
    """Common fields for create and update operations."""

    name: str = Field(..., max_length=255, description="Human‑readable name of the slit")
    description: Optional[str] = Field(
        None, description="Optional free‑form description"
    )
    material: str = Field(..., max_length=100, description="Material of the slit")

    @validator("name")
    def _name_not_empty(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("name must not be empty")
        return v

    @validator("material")
    def _material_not_empty(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("material must not be empty")
        return v


class SlitCreate(SlitBase):
    """Schema used when creating a new slit."""


class SlitUpdate(BaseModel):
    """Schema used for partial updates."""

    name: Optional[str] = Field(None, max_length=255)
    description: Optional[str] = None
    material: Optional[str] = Field(None, max_length=100)

    @validator("name")
    def _name_not_empty(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and not v.strip():
            raise ValueError("name must not be empty")
        return v

    @validator("material")
    def _material_not_empty(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and not v.strip():
            raise ValueError("material must not be empty")
        return v


class SlitRead(SlitBase):
    """Schema returned to the client."""

    id: int

    class Config:
        orm_mode = True


# --------------------------------------------------------------------------- #
# Dependency for DB session (to be overridden by the FastAPI app)
# --------------------------------------------------------------------------- #
async def get_db() -> AsyncSession:
    """
    Placeholder dependency that must be overridden in the FastAPI application
    to provide an AsyncSession instance.

    Raises:
        NotImplementedError: If the dependency is not overridden.
    """
    raise NotImplementedError("Database session dependency not configured")


# --------------------------------------------------------------------------- #
# Helper utilities
# --------------------------------------------------------------------------- #
async def _fetch_slit(
    slit_id: int, db: AsyncSession
) -> Slit:
    """
    Retrieve a Slit instance by its primary key.

    Args:
        slit_id: The primary key of the slit.
        db: Async SQLAlchemy session.

    Returns:
        The matching Slit instance.

    Raises:
        HTTPException: 404 if the slit does not exist.
    """
    stmt = select(Slit).where(Slit.id == slit_id)
    try:
        result = await db.execute(stmt)
    except SQLAlchemyError as exc:
        logger.exception("Database error while fetching slit id=%s", slit_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve slit",
        ) from exc

    slit = result.scalar_one_or_none()
    if slit is None:
        logger.warning("Slit not found: id=%s", slit_id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Slit with id {slit_id} not found",
        )
    return slit


# --------------------------------------------------------------------------- #
# Router definition
# --------------------------------------------------------------------------- #
router = APIRouter(prefix="/slits", tags=["slits"])


@router.post(
    "/",
    response_model=SlitRead,
    status_code=status.HTTP_201_CREATED,
    responses={
        400: {"description": "Invalid input"},
        409: {"description": "Duplicate name"},
        500: {"description": "Internal server error"},
    },
)
async def create_slit(
    payload: SlitCreate, db: AsyncSession = Depends(get_db)
) -> SlitRead:
    """
    Create a new slit record.

    Args:
        payload: Data for the new slit.
        db: Async SQLAlchemy session.

    Returns:
        The created slit as a Pydantic model.

    Raises:
        HTTPException: 409 if name already exists, 500 for other DB errors.
    """
    logger.info("Creating slit with name=%s", payload.name)
    new_slit = Slit(**payload.dict())
    db.add(new_slit)
    try:
        await db.commit()
        await db.refresh(new_slit)
    except IntegrityError:
        await db.rollback()
        logger.warning("Duplicate slit name detected: %s", payload.name)
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="A slit with this name already exists",
        )
    except SQLAlchemyError as exc:
        await db.rollback()
        logger.exception("Database error while creating slit")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create slit",
        ) from exc

    return SlitRead.from_orm(new_slit)


@router.get(
    "/",
    response_model=List[SlitRead],
    responses={200: {"description": "List of slits"}},
)
async def list_slits(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(
        100,
        ge=1,
        le=1000,
        description="Maximum number of records to return (max 1000)",
    ),
    db: AsyncSession = Depends(get_db),
) -> List[SlitRead]:
    """
    Retrieve a paginated list of slits.

    Args:
        skip: Offset for pagination.
        limit: Maximum number of records to return.
        db: Async SQLAlchemy session.

    Returns:
        List of slits.

    Raises:
        HTTPException: 500 for DB errors.
    """
    logger.debug("Listing slits (skip=%s, limit=%s)", skip, limit)
    stmt = select(Slit).offset(skip).limit(limit)
    try:
        result = await db.execute(stmt)
    except SQLAlchemyError as exc:
        logger.exception("Database error while listing slits")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve slits",
        ) from exc

    slits = result.scalars().all()
    return [SlitRead.from_orm(s) for s in slits]


@router.get(
    "/{slit_id}",
    response_model=SlitRead,
    responses={404: {"description": "Slit not found"}},
)
async def get_slit(
    slit_id: int, db: AsyncSession = Depends(get_db)
) -> SlitRead:
    """
    Retrieve a single slit by its ID.

    Args:
        slit_id: Primary key of the slit.
        db: Async SQLAlchemy session.

    Returns:
        The requested slit.

    Raises:
        HTTPException: 404 if not found, 500 for DB errors.
    """
    logger.debug("Fetching slit id=%s", slit_id)
    slit = await _fetch_slit(slit_id, db)
    return SlitRead.from_orm(slit)


@router.patch(
    "/{slit_id}",
    response_model=SlitRead,
    responses={
        400: {"description": "Invalid input"},
        404: {"description": "Slit not found"},
        409: {"description": "Duplicate name"},
        500: {"description": "Internal server error"},
    },
)
async def update_slit(
    slit_id: int,
    payload: SlitUpdate,
    db: AsyncSession = Depends(get_db),
) -> SlitRead:
    """
    Partially update a slit.

    Args:
        slit_id: Primary key of the slit to update.
        payload: Fields to update.
        db: Async SQLAlchemy session.

    Returns:
        The updated slit.

    Raises:
        HTTPException: 404 if not found, 409 on duplicate name,
                      500 for other DB errors.
    """
    logger.info("Updating slit id=%s", slit_id)
    slit = await _fetch_slit(slit_id, db)

    update_data = payload.dict(exclude_unset=True)
    if not update_data:
        logger.debug("No fields supplied for update (id=%s)", slit_id)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields provided for update",
        )

    for key, value in update_data.items():
        setattr(slit, key, value)

    try:
        await db.commit()
        await db.refresh(slit)
    except IntegrityError:
        await db.rollback()
        logger.warning("Duplicate slit name on update: %s", update_data.get("name"))
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="A slit with this name already exists",
        )
    except SQLAlchemyError as exc:
        await db.rollback()
        logger.exception("Database error while updating slit id=%s", slit_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update slit",
        ) from exc

    return SlitRead.from_orm(slit)


@router.delete(
    "/{slit_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    responses={404: {"description": "Slit not found"}},
)
async def delete_slit(
    slit_id: int, db: AsyncSession = Depends(get_db)
) -> None:
    """
    Delete a slit.

    Args:
        slit_id: Primary key of the slit to delete.
        db: Async SQLAlchemy session.

    Raises:
        HTTPException: 404 if not found, 500 for DB errors.
    """
    logger.info("Deleting slit id=%s", slit_id)
    slit = await _fetch_slit(slit_id, db)

    stmt = delete(Slit).where(Slit.id == slit.id)
    try:
        await db.execute(stmt)
        await db.commit()
    except SQLAlchemyError as exc:
        await db.rollback()
        logger.exception("Database error while deleting slit id=%s", slit_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to delete slit",
        ) from exc

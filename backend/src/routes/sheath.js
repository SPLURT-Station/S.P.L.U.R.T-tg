python
"""
backend/src/routes/sheath.py
---------------------------
FastAPI router handling CRUD operations for "Sheath" resources.

Features
--------
* Fully typed request/response models (Pydantic + type hints)
* Comprehensive docstrings (Args, Returns, Raises)
* Structured logging (debug, info, warning, error)
* Input validation & security checks
* Specific error handling with HTTPException
* Pagination with response‑header metadata
* Clean‑code best practices
"""

from __future__ import annotations

import logging
import re
from typing import List

from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Query,
    Request,
    Response,
    status,
)
from sqlalchemy.exc import DBAPIError, IntegrityError, NoResultFound
from sqlalchemy.orm import Session

# Local imports – adjust paths as needed
from .. import deps  # Dependency that provides a DB session
from ..models import Sheath  # SQLAlchemy model
from ..schemas.sheath import SheathCreate, SheathOut, SheathUpdate

router = APIRouter(prefix="/sheaths", tags=["Sheaths"])
log = logging.getLogger(__name__)

# --------------------------------------------------------------------------- #
# Helper utilities
# --------------------------------------------------------------------------- #
def _set_pagination_headers(response: Response, total: int, page: int, limit: int) -> None:
    """
    Populate pagination metadata in response headers.

    Args:
        response: FastAPI ``Response`` object.
        total: Total number of items in the collection.
        page: Current page number (1‑based).
        limit: Number of items per page.
    """
    total_pages = (total + limit - 1) // limit or 1
    response.headers["X-Total-Count"] = str(total)
    response.headers["X-Page"] = str(page)
    response.headers["X-Limit"] = str(limit)
    response.headers["X-Total-Pages"] = str(total_pages)


def _sanitize_string(value: str, field_name: str, max_len: int = 255) -> str:
    """
    Basic sanitisation to prevent injection of HTML/JS payloads.

    Args:
        value: Input string.
        field_name: Name of the field (used for logging).
        max_len: Maximum allowed length.

    Returns:
        The original string if safe.

    Raises:
        ValueError: If the string contains unsafe characters or exceeds length.
    """
    if len(value) > max_len:
        raise ValueError(f"{field_name} exceeds maximum length of {max_len}.")
    if re.search(r"[<>\"'`]", value):
        log.warning("Unsafe characters detected in %s: %s", field_name, value)
        raise ValueError(f"Invalid characters in {field_name}.")
    return value


# --------------------------------------------------------------------------- #
# Endpoints
# --------------------------------------------------------------------------- #
@router.get(
    "/",
    response_model=List[SheathOut],
    status_code=status.HTTP_200_OK,
    summary="List sheaths",
    description="Retrieve a paginated list of sheaths.",
)
async def list_sheaths(
    request: Request,
    response: Response,
    page: int = Query(1, ge=1, description="Page number (1‑based)"),
    limit: int = Query(20, ge=1, le=100, description="Items per page"),
    db: Session = Depends(deps.get_db),
) -> List[SheathOut]:
    """
    Retrieve a paginated collection of sheaths.

    Args:
        request: FastAPI request (used for logging).
        response: FastAPI response (used for pagination headers).
        page: Desired page number (default 1).
        limit: Number of items per page (default 20, max 100).
        db: SQLAlchemy session.

    Returns:
        List of ``SheathOut`` objects.

    Raises:
        HTTPException: 500 if a database error occurs.
    """
    offset = (page - 1) * limit
    log.debug("Listing sheaths – page=%s limit=%s offset=%s", page, limit, offset)

    try:
        query = db.query(Sheath).order_by(Sheath.created_at.desc())
        total = query.count()
        sheaths = query.offset(offset).limit(limit).all()
    except DBAPIError as exc:
        log.error("Database error while listing sheaths: %s", exc, exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Unable to retrieve sheaths.",
        ) from exc

    _set_pagination_headers(response, total, page, limit)
    return sheaths


@router.get(
    "/{sheath_id}",
    response_model=SheathOut,
    status_code=status.HTTP_200_OK,
    summary="Get a sheath",
    description="Retrieve a single sheath by its unique identifier.",
)
async def get_sheath(
    sheath_id: int,
    db: Session = Depends(deps.get_db),
) -> SheathOut:
    """
    Retrieve a single sheath.

    Args:
        sheath_id: Primary key of the sheath.
        db: SQLAlchemy session.

    Returns:
        ``SheathOut`` instance.

    Raises:
        HTTPException: 404 if not found, 500 on DB errors.
    """
    log.debug("Fetching sheath id=%s", sheath_id)
    try:
        sheath = db.get(Sheath, sheath_id)
    except DBAPIError as exc:
        log.error(
            "Database error while fetching sheath %s: %s", sheath_id, exc, exc_info=True
        )
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Unable to retrieve the sheath.",
        ) from exc

    if sheath is None:
        log.warning("Sheath id=%s not found", sheath_id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Sheath not found.",
        )
    return sheath


@router.post(
    "/",
    response_model=SheathOut,
    status_code=status.HTTP_201_CREATED,
    summary="Create a sheath",
    description="Create a new sheath resource.",
)
async def create_sheath(
    payload: SheathCreate,
    db: Session = Depends(deps.get_db),
) -> SheathOut:
    """
    Create a new sheath.

    Args:
        payload: Validated request body.
        db: SQLAlchemy session.

    Returns:
        The newly created ``SheathOut`` object.

    Raises:
        HTTPException: 400 on validation errors, 500 on DB errors.
    """
    log.info("Creating sheath – name=%s", payload.name)

    # Basic sanitisation of user‑provided strings
    try:
        safe_name = _sanitize_string(payload.name, "name")
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc

    new_sheath = Sheath(**payload.dict(exclude_unset=True, exclude={"name"}), name=safe_name)

    try:
        db.add(new_sheath)
        db.commit()
        db.refresh(new_sheath)
    except IntegrityError as exc:
        db.rollback()
        log.warning("Integrity error while creating sheath: %s", exc, exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Sheath creation violates a database constraint.",
        ) from exc
    except DBAPIError as exc:
        db.rollback()
        log.error("Database error while creating sheath: %s", exc, exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Unable to create sheath.",
        ) from exc

    return new_sheath


@router.put(
    "/{sheath_id}",
    response_model=SheathOut,
    status_code=status.HTTP_200_OK,
    summary="Update a sheath",
    description="Update an existing sheath resource.",
)
async def update_sheath(
    sheath_id: int,
    payload: SheathUpdate,
    db: Session = Depends(deps.get_db),
) -> SheathOut:
    """
    Update an existing sheath.

    Args:
        sheath_id: Identifier of the sheath to update.
        payload: Fields to update (partial allowed).
        db: SQLAlchemy session.

    Returns:
        Updated ``SheathOut`` object.

    Raises:
        HTTPException: 404 if not found, 400 on validation, 500 on DB errors.
    """
    log.info("Updating sheath id=%s", sheath_id)

    try:
        sheath = db.get(Sheath, sheath_id)
    except DBAPIError as exc:
        log.error("Database error while fetching sheath %s: %s", sheath_id, exc, exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Unable to fetch sheath for update.",
        ) from exc

    if sheath is None:
        log.warning("Sheath id=%s not found for update", sheath_id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Sheath not found.",
        )

    # Apply sanitisation to mutable string fields
    if payload.name is not None:
        try:
            payload.name = _sanitize_string(payload.name, "name")
        except ValueError as exc:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=str(exc),
            ) from exc

    for field, value in payload.dict(exclude_unset=True).items():
        setattr(sheath, field, value)

    try:
        db.commit()
        db.refresh(sheath)
    except IntegrityError as exc:
        db.rollback()
        log.warning("Integrity error while updating sheath %s: %s", sheath_id, exc, exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Update violates a database constraint.",
        ) from exc
    except DBAPIError as exc:
        db.rollback()
        log.error("Database error while updating sheath %s: %s", sheath_id, exc, exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Unable to update sheath.",
        ) from exc

    return sheath


@router.delete(
    "/{sheath_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete a sheath",
    description="Delete a sheath resource by its identifier.",
)
async def delete_sheath(
    sheath_id: int,
    db: Session = Depends(deps.get_db),
) -> None:
    """
    Delete a sheath.

    Args:
        sheath_id: Identifier of the sheath to delete.
        db: SQLAlchemy session.

    Raises:
        HTTPException: 404 if not found, 500 on DB errors.
    """
    log.info("Deleting sheath id=%s", sheath_id)

    try:
        sheath = db.get(Sheath, sheath_id)
    except DBAPIError as exc:
        log.error("Database error while fetching sheath %s for deletion: %s", sheath_id, exc, exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Unable to fetch sheath for deletion.",
        ) from exc

    if sheath is None:
        log.warning("Sheath id=%s not found for deletion", sheath_id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Sheath not found.",
        )

    try:
        db.delete(sheath)
        db.commit()
    except DBAPIError as exc:
        db.rollback()
        log.error("Database error while deleting sheath %s: %s", sheath_id, exc, exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Unable to delete sheath.",
        ) from exc

    return None

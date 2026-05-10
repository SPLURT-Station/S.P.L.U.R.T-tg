python
# backend/src/server.py
"""
Production‑grade Flask API for ``slit`` and ``sheath`` resources.

Features
--------
* Configuration via ``.env`` (dotenv)
* CORS support
* Structured request validation (Marshmallow)
* Centralised error handling
* Detailed logging (debug, info, warning, error)
* Full type hints and comprehensive docstrings
* Input validation & security checks (content‑type, size limits)
* Pagination for list endpoints
* Performance‑friendly DB sessions
"""

from __future__ import annotations

import os
import logging
from typing import Any, Dict, List, Tuple, Optional

from flask import (
    Flask,
    jsonify,
    request,
    Response,
    abort,
    Blueprint,
)
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from marshmallow import Schema, fields, ValidationError, INCLUDE, validate
from sqlalchemy.exc import SQLAlchemyError, IntegrityError
from dotenv import load_dotenv

# --------------------------------------------------------------------------- #
# Configuration & Logging
# --------------------------------------------------------------------------- #

load_dotenv()  # Load .env into os.environ

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()
logging.basicConfig(
    level=LOG_LEVEL,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger("backend")
handler = logging.StreamHandler()
handler.setLevel(LOG_LEVEL)
formatter = logging.Formatter(
    "%(asctime)s %(levelname)s %(name)s %(message)s",
    "%Y-%m-%d %H:%M:%S",
)
handler.setFormatter(formatter)
logger.addHandler(handler)

# --------------------------------------------------------------------------- #
# Flask & Database Setup
# --------------------------------------------------------------------------- #

MAX_CONTENT_LENGTH = 2 * 1024 * 1024  # 2 MiB request body limit

# Global DB instance – will be initialised in ``create_app``.
db: SQLAlchemy = SQLAlchemy()


def create_app() -> Flask:
    """
    Flask application factory.

    Returns
    -------
    Flask
        Configured Flask application instance.
    """
    app = Flask(__name__)
    CORS(app)

    # Application configuration
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv(
        "DATABASE_URL",
        "postgresql://postgres:postgres@localhost:5432/postgres",
    )
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["JSON_SORT_KEYS"] = False
    app.config["MAX_CONTENT_LENGTH"] = MAX_CONTENT_LENGTH

    # Initialise extensions
    db.init_app(app)

    # Register blueprints / routes
    register_routes(app)

    # Register error handlers
    register_error_handlers(app)

    # Add security headers after each request
    @app.after_request
    def add_security_headers(response: Response) -> Response:
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["Referrer-Policy"] = "no-referrer"
        return response

    return app


# Legacy reference for external tools that import ``app`` directly.
app: Flask = create_app()


# --------------------------------------------------------------------------- #
# Models
# --------------------------------------------------------------------------- #class Slit(db.Model):
    """SQLAlchemy model for a ``Slit`` resource."""

    __tablename__ = "slits"

    id: int = db.Column(db.Integer, primary_key=True)
    name: str = db.Column(db.String(128), nullable=False, unique=True)
    length: float = db.Column(db.Float, nullable=False)
    material: str = db.Column(db.String(64), nullable=False)

    def to_dict(self) -> Dict[str, Any]:
        """Serialise the model into a plain ``dict``."""
        return {
            "id": self.id,
            "name": self.name,
            "length": self.length,
            "material": self.material,
        }


class Sheath(db.Model):
    """SQLAlchemy model for a ``Sheath`` resource."""

    __tablename__ = "sheaths"

    id: int = db.Column(db.Integer, primary_key=True)
    name: str = db.Column(db.String(128), nullable=False, unique=True)
    thickness: float = db.Column(db.Float, nullable=False)
    material: str = db.Column(db.String(64), nullable=False)

    def to_dict(self) -> Dict[str, Any]:
        """Serialise the model into a plain ``dict``."""
        return {
            "id": self.id,
            "name": self.name,
            "thickness": self.thickness,
            "material": self.material,
        }


# --------------------------------------------------------------------------- #
# Schemas (validation & serialisation)
# --------------------------------------------------------------------------- #

def _non_empty_string(value: str) -> bool:
    """Validate that a string is not empty or whitespace only."""
    return isinstance(value, str) and bool(value.strip())


class SlitSchema(Schema):
    """Marshmallow schema for ``Slit``."""

    class Meta:
        unknown = INCLUDE

    id = fields.Int(dump_only=True)
    name = fields.Str(
        required=True,
        validate=[validate.Length(min=1), _non_empty_string],
    )
    length = fields.Float(required=True, validate=validate.Range(min=0, exclusive=True))
    material = fields.Str(
        required=True,
        validate=[validate.Length(min=1), _non_empty_string],
    )


class SheathSchema(Schema):
    """Marshmallow schema for ``Sheath``."""

    class Meta:
        unknown = INCLUDE

    id = fields.Int(dump_only=True)
    name = fields.Str(
        required=True,
        validate=[validate.Length(min=1), _non_empty_string],
    )
    thickness = fields.Float(required=True, validate=validate.Range(min=0, exclusive=True))
    material = fields.Str(
        required=True,
        validate=[validate.Length(min=1), _non_empty_string],
    )


slit_schema = SlitSchema()
slits_schema = SlitSchema(many=True)
sheath_schema = SheathSchema()
sheaths_schema = SheathSchema(many=True)


# --------------------------------------------------------------------------- #
# Helper Functions
# --------------------------------------------------------------------------- #

def json_response(data: Any, status: int = 200) -> Response:
    """
    Return a Flask ``Response`` with JSON payload and proper headers.

    Parameters
    ----------
    data : Any
        JSON‑serialisable content.
    status : int, optional
        HTTP status code (default 200).

    Returns
    -------
    Response
        Flask response object.
    """
    resp = jsonify(data)
    resp.status_code = status
    return resp


def handle_validation_error(err: ValidationError) -> Response:
    """
    Convert a ``ValidationError`` into a JSON error response.

    Parameters
    ----------
    err : ValidationError
        The marshmallow ``ValidationError`` instance.

    Returns
    -------
    Response
        JSON response with error details and HTTP 400 status.
    """
    logger.warning("Validation error: %s", err.messages)
    return json_response({"error": err.messages}, status=400)


def safe_commit() -> None:
    """
    Commit the current DB session, rolling back on failure.

    Raises
    ------
    SQLAlchemyError
        Propagates the original DB error after rollback.
    """
    try:
        db.session.commit()
    except SQLAlchemyError as exc:
        db.session.rollback()
        logger.error("Database commit failed: %s", exc)
        raise


def paginate_query(
    query,
    page: int,
    per_page: int,
) -> Tuple[List[Any], int]:
    """
    Apply pagination to a SQLAlchemy query.

    Parameters
    ----------
    query : sqlalchemy.orm.Query
        The query to paginate.
    page : int
        Requested page number (1‑based).
    per_page : int
        Number of items per page.

    Returns
    -------
    Tuple[List[Any], int]
        (items, total_count)
    """
    total = query.order_by(None).count()
    items = (
        query.offset((page - 1) * per_page)
        .limit(per_page)
        .all()
    )
    return items, total


def validate_json_content_type() -> None:
    """
    Ensure the request has a ``Content-Type`` of ``application/json``.

    Raises
    ------
    werkzeug.exceptions.BadRequest
        If the content type is missing or not JSON.
    """
    if not request.is_json:
        logger.error("Invalid content type: %s", request.content_type)
        abort(400, description="Content-Type must be application/json")


def parse_pagination_params() -> Tuple[int, int]:
    """
    Extract ``page`` and ``per_page`` query parameters with defaults.

    Returns
    -------
    Tuple[int, int]
        ``(page, per_page)`` where both are positive integers.
    """
    try:
        page = int(request.args.get("page", 1))
        per_page = int(request.args.get("per_page", 20))
        if page < 1 or per_page < 1:
            raise ValueError
    except ValueError:
        logger.warning("Invalid pagination parameters")
        abort(400, description="Pagination parameters must be positive integers")
    return page, per_page


# --------------------------------------------------------------------------- #
# Routes
# --------------------------------------------------------------------------- #

def register_routes(app: Flask) -> None:
    """
    Register all API routes on the Flask application.

    Parameters
    ----------
    app : Flask
        The Flask application instance.
    """
    api = Blueprint("api", __name__)

    # -------------------- Slit Endpoints -------------------- #
    @api.route("/slits", methods=["GET"])
    def list_slits() -> Response:
        """
        List all slits with pagination.

        Returns
        -------
        Response
            JSON list of slits and pagination metadata.
        """
        page, per_page = parse_pagination_params()
        query = Slit.query.order_by(Slit.id)
        items, total = paginate_query(query, page, per_page)
        result = {
            "items": slits_schema.dump(items),
            "total": total,
            "page": page,
            "per_page": per_page,
        }
        logger.info("Listed %d slits (page %d)", len(items), page)
        return json_response(result)

    @api.route("/slits/<int:slit_id>", methods=["GET"])
    def get_slit(slit_id: int) -> Response:
        """
        Retrieve a single slit by ID.

        Parameters
        ----------
        slit_id : int
            Identifier of the slit.

        Returns
        -------
        Response
            JSON representation of the slit.
        """
        slit = Slit.query.get_or_404(slit_id)
        logger.debug("Fetched slit %d", slit_id)
        return json_response(slit_schema.dump(slit))

    @api.route("/slits", methods=["POST"])
    def create_slit() -> Response:
        """
        Create a new slit.

        Returns
        -------
        Response
            JSON representation of the created slit.
        """
        validate_json_content_type()
        try:
            data = slit_schema.load(request.get_json())
        except ValidationError as err:
            return handle_validation_error(err)

        slit = Slit(**data)  # type: ignore[arg-type]
        db.session.add(slit)
        try:
            safe_commit()
        except IntegrityError:
            logger.error("Slit creation failed – duplicate name")
            abort(409, description="Slit with this name already exists")
        logger.info("Created slit %d", slit.id)
        return json_response(slit_schema.dump(slit), status=201)

    @api.route("/slits/<int:slit_id>", methods=["PUT"])
    def update_slit(slit_id: int) -> Response:
        """
        Update an existing slit.

        Parameters
        ----------
        slit_id : int
            Identifier of the slit to update.

        Returns
        -------
        Response
            JSON representation of the updated slit.
        """
        validate_json_content_type()
        slit = Slit.query.get_or_404(slit_id)
        try:
            data = slit_schema.load(request.get_json(), partial=True)
        except ValidationError as err:
            return handle_validation_error(err)

        for key, value in data.items():
            setattr(slit, key, value)
        try:
            safe_commit()
        except IntegrityError:
            logger.error("Slit update failed – duplicate name")
            abort(409, description="Slit with this name already exists")
        logger.info("Updated slit %d", slit_id)
        return json_response(slit_schema.dump(slit))

    @api.route("/slits/<int:slit_id>", methods=["DELETE"])
    def delete_slit(slit_id: int) -> Response:
        """
        Delete a slit.

        Parameters
        ----------
        slit_id : int
            Identifier of the slit to delete.

        Returns
        -------
        Response
            Empty response with HTTP 204 status.
        """
        slit = Slit.query.get_or_404(slit_id)
        db.session.delete(slit)
        safe_commit()
        logger.info("Deleted slit %d", slit_id)
        return Response(status=204)

    # -------------------- Sheath Endpoints -------------------- #
    @api.route("/sheaths", methods=["GET"])
    def list_sheaths() -> Response:
        """
        List all sheaths with pagination.

        Returns
        -------
        Response
            JSON list of sheaths and pagination metadata.
        """
        page, per_page = parse_pagination_params()
        query = Sheath.query.order_by(Sheath.id)
        items, total = paginate_query(query, page, per_page)
        result = {
            "items": sheaths_schema.dump(items),
            "total": total,
            "page": page,
            "per_page": per_page,
        }
        logger.info("Listed %d sheaths (page %d)", len(items), page)
        return json_response(result)

    @api.route("/sheaths/<int:sheath_id>", methods=["GET"])
    def get_sheath(sheath_id: int) -> Response:
        """
        Retrieve a single sheath by ID.

        Parameters
        ----------
        sheath_id : int
            Identifier of the sheath.

        Returns
        -------
        Response
            JSON representation of the sheath.
        """
        sheath = Sheath.query.get_or_404(sheath_id)
        logger.debug("Fetched sheath %d", sheath_id)
        return json_response(sheath_schema.dump(sheath))

    @api.route("/sheaths", methods=["POST"])
    def create_sheath() -> Response:
        """
        Create a new sheath.

        Returns
        -------
        Response
            JSON representation of the created sheath.
        """
        validate_json_content_type()
        try:
            data = sheath_schema.load(request.get_json())
        except ValidationError as err:
            return handle_validation_error(err)

        sheath = Sheath(**data)  # type: ignore[arg-type]
        db.session.add(sheath)
        try:
            safe_commit()
        except IntegrityError:
            logger.error("Sheath creation failed – duplicate name")
            abort(409, description="Sheath with this name already exists")
        logger.info("Created sheath %d", sheath.id)
        return json_response(sheath_schema.dump(sheath), status=201)

    @api.route("/sheaths/<int:sheath_id>", methods=["PUT"])
    def update_sheath(sheath_id: int) -> Response:
        """
        Update an existing sheath.

        Parameters
        ----------
        sheath_id : int
            Identifier of the sheath to update.

        Returns
        -------
        Response
            JSON representation of the updated sheath.
        """
        validate_json_content_type()
        sheath = Sheath.query.get_or_404(sheath_id)
        try:
            data = sheath_schema.load(request.get_json(), partial=True)
        except ValidationError as err:
            return handle_validation_error(err)

        for key, value in data.items():
            setattr(sheath, key, value)
        try:
            safe_commit()
        except IntegrityError:
            logger.error("Sheath update failed – duplicate name")
            abort(409, description="Sheath with this name already exists")
        logger.info("Updated sheath %d", sheath_id)
        return json_response(sheath_schema.dump(sheath))

    @api.route("/sheaths/<int:sheath_id>", methods=["DELETE"])
    def delete_sheath(sheath_id: int) -> Response:
        """
        Delete a sheath.

        Parameters
        ----------
        sheath_id : int
            Identifier of the sheath to delete.

        Returns
        -------
        Response
            Empty response with HTTP 204 status.
        """
        sheath = Sheath.query.get_or_404(sheath_id)
        db.session.delete(sheath)
        safe_commit()
        logger.info("Deleted sheath %d", sheath_id)
        return Response(status=204)

    app.register_blueprint(api, url_prefix="/api")


# --------------------------------------------------------------------------- #
# Error Handlers
# --------------------------------------------------------------------------- #

def register_error_handlers(app: Flask) -> None:
    """
    Register JSON error handlers for common HTTP errors.

    Parameters
    ----------
    app : Flask
        The Flask application instance.
    """

    @app.errorhandler(400)
    def bad_request(error) -> Response:
        logger.warning("400 Bad Request: %s", error)
        return json_response({"error": str(error)}, status=400)

    @app.errorhandler(404)
    def not_found(error) -> Response:
        logger.warning("404 Not Found: %s", error)
        return json_response({"error": "Resource not found"}, status=404)

    @app.errorhandler(409)
    def conflict(error) -> Response:
        logger.warning("409 Conflict: %s", error)
        return json_response({"error": str(error)}, status=409)

    @app.errorhandler(500)
    def internal_error(error) -> Response:
        logger.exception("500 Internal Server Error")
        return json_response({"error": "Internal server error"}, status=500)


# --------------------------------------------------------------------------- #
# Application Entry Point
# --------------------------------------------------------------------------- #

if __name__ == "__main__":
    # Ensure tables exist before first request
    with app.app_context():
        db.create_all()
    logger.info("Starting Flask server")
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", 5000)), debug=False)

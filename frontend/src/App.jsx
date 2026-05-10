#!/usr/bin/env python3
"""
Production‑grade Flask application implementing a RESTful API for
“slit” and “sheath” resources.

Features
--------
* CRUD endpoints for Slit and Sheath.
* PostgreSQL persistence via SQLAlchemy.
* Request validation with Marshmallow.
* Centralised error handling.
* Structured logging (JSON format).
* Environment‑driven configuration.
* Database migrations support (Flask‑Migrate).
"""

import os
import logging
from logging.config import dictConfig
from typing import Any, Dict, List, Optional

from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from marshmallow import Schema, fields, validate, ValidationError, post_load

# ----------------------------------------------------------------------
# Configuration & Logging
# ----------------------------------------------------------------------
class Config:
    """Flask configuration loaded from environment variables."""
    DEBUG: bool = os.getenv("FLASK_DEBUG", "false").lower() == "true"
    TESTING: bool = os.getenv("FLASK_TESTING", "false").lower() == "true"
    SQLALCHEMY_DATABASE_URI: str = os.getenv(
        "DATABASE_URL",
        "postgresql://postgres:postgres@localhost:5432/slit_sheath_db",
    )
    SQLALCHEMY_TRACK_MODIFICATIONS: bool = False
    JSONIFY_PRETTYPRINT_REGULAR: bool = False


LOGGING_CONFIG = {
    "version": 1,
    "formatters": {
        "json": {
            "format": (
                '{"time":"%(asctime)s","level":"%(levelname)s",'
                '"module":"%(module)s","message":"%(message)s"}'
            ),
            "datefmt": "%Y-%m-%dT%H:%M:%S%z",
        }
    },
    "handlers": {
        "default": {
            "class": "logging.StreamHandler",
            "formatter": "json",
        }
    },
    "root": {"level": "INFO", "handlers": ["default"]},
}
dictConfig(LOGGING_CONFIG)
logger = logging.getLogger(__name__)

# ----------------------------------------------------------------------
# Flask Application & Extensions
# ----------------------------------------------------------------------
app: Flask = Flask(__name__)
app.config.from_object(Config)

db: SQLAlchemy = SQLAlchemy(app)
migrate: Migrate = Migrate(app, db)


# ----------------------------------------------------------------------
# Database Models
# ----------------------------------------------------------------------
class Slit(db.Model):
    """Represents a Slit resource."""

    __tablename__ = "slits"

    id: int = db.Column(db.Integer, primary_key=True)
    name: str = db.Column(db.String(120), nullable=False, unique=True)
    length: float = db.Column(db.Float, nullable=False)
    width: float = db.Column(db.Float, nullable=False)

    def __repr__(self) -> str:
        return f"<Slit {self.id} {self.name}>"


class Sheath(db.Model):
    """Represents a Sheath resource."""

    __tablename__ = "sheaths"

    id: int = db.Column(db.Integer, primary_key=True)
    material: str = db.Column(db.String(120), nullable=False)
    thickness: float = db.Column(db.Float, nullable=False)
    compatible_slit_id: int = db.Column(
        db.Integer, db.ForeignKey("slits.id"), nullable=False
    )
    compatible_slit: Slit = db.relationship("Slit", backref=db.backref("sheaths", lazy=True))

    def __repr__(self) -> str:
        return f"<Sheath {self.id} {self.material}>"


# ----------------------------------------------------------------------
# Schemas (Marshmallow)
# ----------------------------------------------------------------------
class SlitSchema(Schema):
    """Marshmallow schema for Slit validation and serialization."""

    id = fields.Int(dump_only=True)
    name = fields.Str(
        required=True,
        validate=validate.Length(min=1, max=120),
        error_messages={"required": "Name is required."},
    )
    length = fields.Float(
        required=True,
        validate=validate.Range(min=0.0),
        error_messages={"required": "Length is required."},
    )
    width = fields.Float(
        required=True,
        validate=validate.Range(min=0.0),
        error_messages={"required": "Width is required."},
    )

    @post_load
    def make_slit(self, data: Dict[str, Any], **_: Any) -> Slit:
        return Slit(**data)


class SheathSchema(Schema):
    """Marshmallow schema for Sheath validation and serialization."""

    id = fields.Int(dump_only=True)
    material = fields.Str(
        required=True,
        validate=validate.Length(min=1, max=120),
        error_messages={"required": "Material is required."},
    )
    thickness = fields.Float(
        required=True,
        validate=validate.Range(min=0.0),
        error_messages={"required": "Thickness is required."},
    )
    compatible_slit_id = fields.Int(
        required=True,
        error_messages={"required": "compatible_slit_id is required."},
    )

    @post_load
    def make_sheath(self, data: Dict[str, Any], **_: Any) -> Sheath:
        return Sheath(**data)


slit_schema = SlitSchema()
slits_schema = SlitSchema(many=True)
sheath_schema = SheathSchema()
sheaths_schema = SheathSchema(many=True)


# ----------------------------------------------------------------------
# Error Handlers
# ----------------------------------------------------------------------
@app.errorhandler(ValidationError)
def handle_validation_error(err: ValidationError):
    """Return JSON response for Marshmallow validation errors."""
    logger.warning("Validation error: %s", err.messages)
    return jsonify({"error": err.messages}), 400


@app.errorhandler(404)
def handle_not_found(error):
    """Return JSON response for 404 errors."""
    logger.info("Resource not found: %s", request.path)
    return jsonify({"error": "Resource not found"}), 404


@app.errorhandler(500)
def handle_internal_error(error):
    """Return JSON response for unexpected server errors."""
    logger.exception("Internal server error")
    return jsonify({"error": "Internal server error"}), 500


# ----------------------------------------------------------------------
# Helper Functions
# ----------------------------------------------------------------------
def get_json_body() -> Dict[str, Any]:
    """Parse JSON request body, handling errors uniformly."""
    if not request.is_json:
        logger.warning("Request content type is not JSON")
        raise ValidationError({"json": ["Request body must be JSON"]})
    return request.get_json()


# ----------------------------------------------------------------------
# Routes – Slit
# ----------------------------------------------------------------------
@app.route("/api/slits", methods=["GET"])
def list_slits():
    """Return a list of all slits."""
    slits: List[Slit] = Slit.query.all()
    result = slits_schema.dump(slits)
    logger.info("Listed %d slits", len(slits))
    return jsonify(result), 200


@app.route("/api/slits/<int:slit_id>", methods=["GET"])
def get_slit(slit_id: int):
    """Retrieve a single slit by ID."""
    slit: Optional[Slit] = Slit.query.get_or_404(slit_id)
    result = slit_schema.dump(slit)
    logger.info("Fetched slit %d", slit_id)
    return jsonify(result), 200


@app.route("/api/slits", methods=["POST"])
def create_slit():
    """Create a new slit."""
    data = get_json_body()
    slit: Slit = slit_schema.load(data)
    db.session.add(slit)
    db.session.commit()
    logger.info("Created slit %d", slit.id)
    return jsonify(slit_schema.dump(slit)), 201


@app.route("/api/slits/<int:slit_id>", methods=["PUT"])
def update_slit(slit_id: int):
    """Update an existing slit."""
    slit: Slit = Slit.query.get_or_404(slit_id)
    data = get_json_body()
    updated: Slit = slit_schema.load(data, partial=True)
    for key, value in data.items():
        setattr(slit, key, value)
    db.session.commit()
    logger.info("Updated slit %d", slit_id)
    return jsonify(slit_schema.dump(slit)), 200


@app.route("/api/slits/<int:slit_id>", methods=["DELETE"])
def delete_slit(slit_id: int):
    """Delete a slit."""
    slit: Slit = Slit.query.get_or_404(slit_id)
    db.session.delete(slit)
    db.session.commit()
    logger.info("Deleted slit %d", slit_id)
    return "", 204


# ----------------------------------------------------------------------
# Routes – Sheath
# ----------------------------------------------------------------------
@app.route("/api/sheaths", methods=["GET"])
def list_sheaths():
    """Return a list of all sheaths."""
    sheaths: List[Sheath] = Sheath.query.all()
    result = sheaths_schema.dump(sheaths)
    logger.info("Listed %d sheaths", len(sheaths))
    return jsonify(result), 200


@app.route("/api/sheaths/<int:sheath_id>", methods=["GET"])
def get_sheath(sheath_id: int):
    """Retrieve a single sheath by ID."""
    sheath: Optional[Sheath] = Sheath.query.get_or_404(sheath_id)
    result = sheath_schema.dump(sheath)
    logger.info("Fetched sheath %d", sheath_id)
    return jsonify(result), 200


@app.route("/api/sheaths", methods=["POST"])
def create_sheath():
    """Create a new sheath."""
    data = get_json_body()
    sheath: Sheath = sheath_schema.load(data)
    # Ensure referenced Slit exists
    if not Slit.query.get(sheath.compatible_slit_id):
        logger.warning(
            "Sheath creation failed – Slit %d does not exist",
            sheath.compatible_slit_id,
        )
        raise ValidationError(
            {"compatible_slit_id": ["Referenced Slit does not exist.}
        )
    db.session.add(sheath)
    db.session.commit()
    logger.info("Created sheath %d", sheath.id)
    return jsonify(sheath_schema.dump(sheath)), 201


@app.route("/api/sheaths/<int:sheath_id>", methods=["PUT"])
def update_sheath(sheath_id: int):
    """Update an existing sheath."""
    sheath: Sheath = Sheath.query.get_or_404(sheath_id)
    data = get_json_body()
    updated: Sheath = sheath_schema.load(data, partial=True)
    if "compatible_slit_id" in data:
        if not Slit.query.get(data["compatible_slit_id"]):
            logger.warning(
                "Sheath update failed – Slit %d does not exist",
                data["compatible_slit_id"],
            )
            raise ValidationError(
                {"compatible_slit_id": ["Referenced Slit does not exist.}
            )
    for key, value in data.items():
        setattr(sheath, key, value)
    db.session.commit()
    logger.info("Updated sheath %d", sheath_id)
    return jsonify(sheath_schema.dump(sheath)), 200


@app.route("/api/sheaths/<int:sheath_id>", methods=["DELETE"])
def delete_sheath(sheath_id: int):
    """Delete a sheath."""
    sheath: Sheath = Sheath.query.get_or_404(sheath_id)
    db.session.delete(sheath)
    db.session.commit()
    logger.info("Deleted sheath %d", sheath_id)
    return "", 204


# ----------------------------------------------------------------------
# Application Entry Point
# ----------------------------------------------------------------------
def create_app() -> Flask:
    """Factory pattern for creating a Flask app instance."""
    return app


if __name__ == "__main__":
    # Enable Flask's built‑in server only for development.
    # In production use a WSGI server (gunicorn, uwsgi, etc.).
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "5000")))
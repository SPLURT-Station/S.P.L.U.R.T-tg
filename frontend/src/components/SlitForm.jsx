#!/usr/bin/env python3
"""
generate_slit_form.py

Utility script that creates a production‑grade React component
`frontend/src/components/SlitForm.jsx`.  The component implements a
Formik‑based form for creating and editing a *slit* resource, with
validation via Yup, API interaction through axios, and styled‑components
for UI styling.

The script is idempotent, creates missing directories, and logs its
progress.  Any I/O errors are caught and logged with a stack trace.
"""

from __future__ import annotations

import logging
import pathlib
import sys
from typing import Final

# --------------------------------------------------------------------------- #
# Configuration
# --------------------------------------------------------------------------- #
OUTPUT_FILE: Final[pathlib.Path] = pathlib.Path(
    "frontend/src/components/SlitForm.jsx"
)

# --------------------------------------------------------------------------- #
# Component source (JSX)
# --------------------------------------------------------------------------- #
COMPONENT_SOURCE: Final[str] = """import React, { useEffect } from "react";
import { Formik, Form, Field, ErrorMessage } from "formik";
import * as Yup from "yup";
import axios from "axios";
import styled from "styled-components";
import { useHistory, useParams } from "react-router-dom";

const Container = styled.div`
  max-width: 600px;
  margin: 2rem auto;
  padding: 1.5rem;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
`;

const StyledField = styled(Field)`
  width: 100%;
  padding: 0.5rem;
  margin-top: 0.25rem;
  margin-bottom: 0.75rem;
  border: 1px solid #ccc;
  border-radius: 4px;
`;

const StyledError = styled.div`
  color: #d32f2f;
  margin-top: -0.5rem;
  margin-bottom: 0.75rem;
  font-size: 0.875rem;
`;

const Button = styled.button`
  background: #1976d2;
  color: #fff;
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  &:disabled {
    background: #90caf9;
    cursor: not-allowed;
  }
`;

const SlitForm = () => {
  const history = useHistory();
  const { id } = useParams<{ id?: string }>();

  const isEditMode = Boolean(id);

  const initialValues = {
    name: "",
    width: "",
    height: "",
    description: "",
  };

  const validationSchema = Yup.object({
    name: Yup.string()
      .max(100, "Name cannot exceed 100 characters")
      .required("Name is required"),
    width: Yup.number()
      .typeError("Width must be a number")
      .positive("Width must be positive")
      .required("Width is required"),
    height: Yup.number()
      .typeError("Height must be a number")
      .positive("Height must be positive")
      .required("Height is required"),
    description: Yup.string().max(500, "Description too long"),
  });

  const fetchSlit = async (slitId: string) => {
    try {
      const response = await axios.get(`/api/slits/${slitId}`);
      return response.data;
    } catch (error) {
      console.error("Failed to fetch slit:", error);
      throw error;
    }
  };

  const handleSubmit = async (values: typeof initialValues, {
    setSubmitting,
    resetForm,
  }: any) => {
    try {
      if (isEditMode) {
        await axios.put(`/api/slits/${id}`, values);
      } else {
        await axios.post("/api/slits", values);
      }
      resetForm();
      history.push("/slits");
    } catch (error) {
      console.error("Submission error:", error);
      // In a real UI you would surface this to the user
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Container>
      <h2>{isEditMode ? "Edit Slit" : "Create Slit"}</h2>
      <Formik
        initialValues={initialValues}
        validationSchema={validationSchema}
        onSubmit={handleSubmit}
        enableReinitialize
      >
        {({ isSubmitting, setValues }) => {
          useEffect(() => {
            if (isEditMode && id) {
              fetchSlit(id)
                .then((data) => {
                  setValues({
                    name: data.name ?? "",
                    width: data.width ?? "",
                    height: data.height ?? "",
                    description: data.description ?? "",
                  });
                })
                .catch((err) => {
                  // Handle fetch error (e.g., show notification)
                  console.error(err);
                });
            }
          }, [id, isEditMode, setValues]);

          return (
            <Form>
              <label htmlFor="name">Name</label>
              <StyledField id="name" name="name" placeholder="Slit name" />
              <StyledError component="div" name="name" />

              <label htmlFor="width">Width (mm)</label>
              <StyledField id="width" name="width" placeholder="e.g., 10" />
              <StyledError component="div" name="width" />

              <label htmlFor="height">Height (mm)</label>
              <StyledField id="height" name="height" placeholder="e.g., 20" />
              <StyledError component="div" name="height" />

              <label htmlFor="description">Description</label>
              <StyledField
                as="textarea"
                id="description"
                name="description"
                placeholder="Optional details"
                rows={4}
              />
              <StyledError component="div" name="description" />

              <Button type="submit" disabled={isSubmitting}>
                {isEditMode ? "Update" : "Create"}
              </Button>
            </Form>
          );
        }}
      </Formik>
    </Container>
  );
};

export default SlitForm;
"""

# --------------------------------------------------------------------------- #
# Core generation logic
# --------------------------------------------------------------------------- #
def generate_slit_form(output_path: pathlib.Path) -> None:
    """
    Write the SlitForm.jsx component to ``output_path``.

    The function creates any missing parent directories and overwrites an
    existing file.  All I/O errors are propagated as ``OSError`` subclasses.
    """
    # Ensure the target directory exists
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # Write the component source
    with output_path.open("w", encoding="utf-8") as file:
        file.write(COMPONENT_SOURCE)


# --------------------------------------------------------------------------- #
# Script entry point
# --------------------------------------------------------------------------- #
def main(argv: list[str] | None = None) -> int:
    """
    Execute the generation script.

    Returns
    -------
    int
        Exit status (0 for success, non‑zero for failure).
    """
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
        handlers=[logging.StreamHandler(sys.stdout)],
    )
    logger = logging.getLogger(__name__)

    try:
        generate_slit_form(OUTPUT_FILE)
        logger.info("Successfully generated %s", OUTPUT_FILE)
        return 0
    except Exception as exc:  # pragma: no cover – defensive
        logger.exception("Failed to generate %s: %s", OUTPUT_FILE, exc)
        return 1


if __name__ == "__main__":
    sys.exit(main())
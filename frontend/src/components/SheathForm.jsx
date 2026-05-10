// frontend/src/components/SheathForm.jsx
/**
 * SheathForm – React component for creating or editing a sheath.
 *
 * Props:
 *   - initialValues?: object – Optional initial values for edit mode.
 *   - onSuccess?: (data: object) => void – Callback after successful submit.
 *   - onCancel?: () => void – Callback when the user cancels the form.
 *
 * The form uses Formik for state management, Yup for validation,
 * styled‑components for styling, and axios for API communication.
 *
 * All network errors are caught and displayed to the user.
 */

import React, { useState } from "react";
import PropTypes from "prop-types";
import { Formik, Form, Field, ErrorMessage } from "formik";
import * as Yup from "yup";
import styled from "styled-components";
import axios from "axios";

/* Styled components */
const Container = styled.div`
  max-width: 600px;
  margin: 0 auto;
  padding: 1rem;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
`;

const Title = styled.h2`
  margin-bottom: 1rem;
  font-size: 1.5rem;
  color: #333;
`;

const FormField = styled.div`
  margin-bottom: 1rem;
`;

const Label = styled.label`
  display: block;
  margin-bottom: 0.25rem;
  font-weight: 600;
`;

const StyledInput = styled(Field)`
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
`;

const StyledSelect = styled(Field)`
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
`;

const StyledTextarea = styled(Field)`
  width: 100%;
  height: 120px;
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  resize: vertical;
`;

const ErrorText = styled.div`
  color: #d8000c;
  margin-top: 0.25rem;
  font-size: 0.875rem;
`;

const ButtonGroup = styled.div`
  display: flex;
  justify-content: flex-end;
  gap: 0.5rem;
`;

const Button = styled.button`
  padding: 0.5rem 1rem;
  font-weight: 600;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  background: ${(props) => (props.primary ? "#007bff" : "#6c757d")};
  color: #fff;
  &:disabled {
    opacity: 0.65;
    cursor: not-allowed;
  }
`;

const LoadingOverlay = styled.div`
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.75);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
  color: #333;
`;

/* Validation schema */
const SheathSchema = Yup.object().shape({
  name: Yup.string()
    .max(100, "Name must be at most 100 characters")
    .required("Name is required"),
  description: Yup.string().max(500, "Description must be at most 500 characters"),
  length: Yup.number()
    .positive("Length must be positive")
    .required("Length is required"),
  material: Yup.string().required("Material is required"),
  color: Yup.string().required("Color is required"),
});

/* Default initial values */
const emptySheath = {
  name: "",
  description: "",
  length: "",
  material: "",
  color: "",
};

const SheathForm = ({ initialValues, onSuccess, onCancel }) => {
  const [loading, setLoading] = useState(false);
  const [apiError, setApiError] = useState("");

  const isEditMode = Boolean(initialValues && initialValues.id);
  const formTitle = isEditMode ? "Edit Sheath" : "Create Sheath";

  const handleSubmit = async (values, { setSubmitting }) => {
    setLoading(true);
    setApiError("");
    try {
      const payload = {
        name: values.name.trim(),
        description: values.description.trim(),
        length: Number(values.length),
        material: values.material.trim(),
        color: values.color.trim(),
      };

      let response;
      if (isEditMode) {
        response = await axios.put(`/api/sheaths/${initialValues.id}`, payload);
      } else {
        response = await axios.post("/api/sheaths", payload);
      }

      console.info("Sheath submission successful:", response.data);
      if (onSuccess) onSuccess(response.data);
    } catch (err) {
      console.error("Sheath submission failed:", err);
      const message =
        err.response?.data?.message ||
        err.message ||
        "An unexpected error occurred.";
      setApiError(message);
    } finally {
      setLoading(false);
      setSubmitting(false);
    }
  };

  return (
    <Container>
      <Title>{formTitle}</Title>
      <Formik
        initialValues={initialValues ? { ...emptySheath, ...initialValues } : emptySheath}
        validationSchema={SheathSchema}
        onSubmit={handleSubmit}
      >
        {({ isSubmitting }) => (
          <Form>
            <FormField>
              <Label htmlFor="name">Name</Label>
              <StyledInput id="name" name="name" placeholder="Sheath name" />
              <ErrorMessage name="name" component={ErrorText} />
            </FormField>

            <FormField>
              <Label htmlFor="description">Description</Label>
              <StyledTextarea
                as="textarea"
                id="description"
                name="description"
                placeholder="Optional description"
              />
              <ErrorMessage name="description" component={ErrorText} />
            </FormField>

            <FormField>
              <Label htmlFor="length">Length (mm)</Label>
              <StyledInput id="length" name="length" type="number" placeholder="e.g., 150" />
              <ErrorMessage name="length" component={ErrorText} />
            </FormField>

            <FormField>
              <Label htmlFor="material">Material</Label>
              <StyledSelect id="material" name="material" as="select">
                <option value="">Select material</option>
                <option value="steel">Steel</option>
                <option value="titanium">Titanium</option>
                <option value="carbon-fiber">Carbon Fiber</option>
                <option value="plastic">Plastic</option>
              </StyledSelect>
              <ErrorMessage name="material" component={ErrorText} />
            </FormField>

            <FormField>
              <Label htmlFor="color">Color</Label>
              <StyledInput id="color" name="color" placeholder="e.g., #ff0000 or red" />
              <ErrorMessage name="color" component={ErrorText} />
            </FormField>

            {apiError && <ErrorText>{apiError}</ErrorText>}

            <ButtonGroup>
              <Button type="button" onClick={onCancel} disabled={isSubmitting}>
                Cancel
              </Button>
              <Button type="submit" primary disabled={isSubmitting}>
                {isEditMode ? "Update" : "Create"}
              </Button>
            </ButtonGroup>

            {loading && <LoadingOverlay>Saving…</LoadingOverlay>}
          </Form>
        )}
      </Formik>
    </Container>
  );
};

SheathForm.propTypes = {
  initialValues: PropTypes.shape({
    id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
    name: PropTypes.string,
    description: PropTypes.string,
    length: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
    material: PropTypes.string,
    color: PropTypes.string,
  }),
  onSuccess: PropTypes.func,
  onCancel: PropTypes.func,
};

SheathForm.defaultProps = {
  initialValues: null,
  onSuccess: null,
  onCancel: null,
};

export default SheathForm;
/**
 * PreviewPane.jsx
 *
 * Visual preview of the configured slit/sheath combination.
 *
 * Props:
 *   - slit:   object  // configuration for the slit (e.g., id, type, dimensions)
 *   - sheath: object  // configuration for the sheath (e.g., id, material, dimensions)
 *
 * The component contacts the backend preview endpoint to retrieve a rendered image.
 * It displays a loading spinner while fetching, shows the image when ready,
 * and renders an error message if the request fails.
 *
 * Dependencies:
 *   - react
 *   - prop-types
 *   - styled-components
 *   - axios
 */

import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";
import styled, { css } from "styled-components";
import axios from "axios";

/* Styled components ------------------------------------------------------- */

const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  padding: 1rem;
  box-sizing: border-box;
`;

const ImageWrapper = styled.div`
  position: relative;
  width: 100%;
  max-width: 500px;
  aspect-ratio: 16 / 9;
  background: #f5f5f5;
  border: 1px solid #ddd;
  overflow: hidden;
  border-radius: 8px;
`;

const StyledImg = styled.img`
  width: 100%;
  height: 100%;
  object-fit: contain;
`;

const Placeholder = styled.div`
  width: 100%;
  height: 100%;
  background: #eaeaea;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #777;
  font-size: 1.2rem;
`;

const Message = styled.div`
  margin-top: 1rem;
  font-size: 0.9rem;
  color: #555;
`;

const Spinner = styled.div`
  border: 4px solid #f3f3f3;
  border-top: 4px solid #555;
  border-radius: 50%;
  width: 48px;
  height: 48px;
  animation: spin 0.8s linear infinite;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);

  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }
`;

/* Helper ----------------------------------------------------------------- */

const buildPreviewUrl = (slit, sheath) => {
  const base = "/api/preview";
  const params = new URLSearchParams();

  if (slit && slit.id) params.append("slitId", slit.id);
  if (sheath && sheath.id) params.append("sheathId", sheath.id);

  // Optional extra parameters (dimensions, material, etc.)
  if (slit && slit.dimensions) params.append("slitDim", slit.dimensions);
  if (sheath && sheath.material) params.append("sheathMat", sheath.material);

  return `${base}?${params.toString()}`;
};

/* Main component ---------------------------------------------------------- */

const PreviewPane = ({ slit, sheath }) => {
  const [imageSrc, setImageSrc] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Fetch preview whenever slit or sheath changes
  useEffect(() => {
    const fetchPreview = async () => {
      setLoading(true);
      setError(null);
      setImageSrc(null);

      try {
        const url = buildPreviewUrl(slit, sheath);
        const response = await axios.get(url, { responseType: "blob" });

        // Convert blob to object URL for <img> src
        const imgUrl = URL.createObjectURL(response.data);
        setImageSrc(imgUrl);
      } catch (err) {
        console.error("PreviewPane: failed to fetch preview", err);
        setError(
          err.response?.data?.message ||
            "Unable to load preview. Please check your configuration."
        );
      } finally {
        setLoading(false);
      }
    };

    // Only request if both configurations are present
    if (slit && sheath) {
      fetchPreview();
    } else {
      setError("Both slit and sheath must be selected to generate a preview.");
    }

    // Cleanup object URLs on unmount or when src changes
    return () => {
      if (imageSrc) URL.revokeObjectURL(imageSrc);
    };
  }, [slit, sheath]);

  return (
    <Container>
      <ImageWrapper>
        {loading && <Spinner />}
        {error && (
          <Placeholder role="alert" aria-live="assertive">
            {error}
          </Placeholder>
        )}
        {imageSrc && !loading && !error && (
          <StyledImg src={imageSrc} alt="Slit/Sheath preview" />
        )}
        {!imageSrc && !loading && !error && (
          <Placeholder>
            Preview will appear here once a slit and sheath are selected.
          </Placeholder>
        )}
      </ImageWrapper>

      <Message>
        {loading && "Generating preview…"}
        {error && "Error: " + error}
        {!loading && !error && "Preview is up‑to‑date."}
      </Message>
    </Container>
  );
};

/* PropTypes --------------------------------------------------------------- */

PreviewPane.propTypes = {
  slit: PropTypes.shape({
    id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
    dimensions: PropTypes.string,
    // Add any other slit‑specific fields you need
  }).isRequired,

  sheath: PropTypes.shape({
    id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
    material: PropTypes.string,
    // Add any other sheath‑specific fields you need
  }).isRequired,
};

export default PreviewPane;
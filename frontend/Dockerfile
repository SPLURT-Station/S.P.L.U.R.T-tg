# ------------------------------------------------------------
# frontend/Dockerfile
# ------------------------------------------------------------
# Multi‑stage build for a production‑ready React SPA.
# ------------------------------------------------------------

# ---------- Stage 1: Build ----------
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install build‑time dependencies
# Using package*.json to leverage Docker cache
COPY package.json package-lock.json ./
RUN npm ci --silent

# Copy source code and build
COPY . .
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=${REACT_APP_API_URL}
RUN npm run build --silent

# ---------- Stage 2: Runtime ----------
FROM nginx:1.25-alpine

# Create a non‑root user (nginx already runs as nginx)
# but ensure file permissions are safe
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy built assets from builder
COPY --from=builder /app/build /usr/share/nginx/html

# Remove default nginx config and add custom one
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

# Adjust ownership for the non‑root user
RUN chown -R appuser:appgroup /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Healthcheck to verify Nginx is serving content
HEALTHCHECK --interval=30s --timeout=5s \
  CMD wget -qO- http://localhost/ || exit 1

# Switch to non‑root user
USER appuser

# Entrypoint (default from nginx image)
CMD ["nginx", "-g", "daemon off;"]
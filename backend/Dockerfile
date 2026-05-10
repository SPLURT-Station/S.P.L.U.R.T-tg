# backend/Dockerfile
# Production‑grade Docker image for the Node.js/Express backend service

# ---- Build Stage -----------------------------------------------------------
FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache python3 make g++

# Set working directory
WORKDIR /app

# Install only production dependencies first for caching
COPY package*.json ./
RUN npm ci --omit=dev

# Copy source code and compile TypeScript (if applicable)
COPY . .
RUN npm run build

# ---- Runtime Stage ---------------------------------------------------------
FROM node:20-alpine

# Create a non‑root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy production dependencies from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8080

# Expose the application port
EXPOSE 8080

# Switch to non‑root user
USER appuser

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD wget -qO- http://localhost:${PORT}/health || exit 1

# Start the application
CMD ["node", "dist/index.js"]
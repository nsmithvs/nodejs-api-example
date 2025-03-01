# Use Node.js Alpine as base image for smaller size and reduced attack surface
FROM node:18-alpine AS base

# Create a non-root user and group
RUN addgroup -S nodeapp && \
    adduser -S nodeuser -G nodeapp

# Set working directory
WORKDIR /app

# Install dependencies as a separate layer to leverage Docker caching
FROM base AS dependencies
# Copy package.json and package-lock.json
COPY package*.json ./
# Install production dependencies only
RUN npm ci --only=production

# Final image
FROM base

# Copy from dependencies stage
COPY --from=dependencies /app/node_modules ./node_modules

# Copy application code
COPY . .

# Set proper ownership
RUN chown -R nodeuser:nodeapp /app

# Use the non-root user
USER nodeuser

# Expose the port the app runs on
EXPOSE 3000

# Define health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/hello-world || exit 1

# Start the application
CMD ["node", "index.js"]
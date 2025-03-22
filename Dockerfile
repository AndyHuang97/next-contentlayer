# Base image for dependencies
FROM node:16-bullseye-slim AS build

# Set working directory
WORKDIR /app

# Set environment variable to install only production dependencies
ENV NODE_ENV=production

# Copy package.json and package-lock.json first for better caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --no-progress && npm cache clean --force

# Copy application files
COPY . ./

# Build the app
RUN npm run build

# Final runtime image
FROM node:16-bullseye-slim AS runtime

WORKDIR /app

#RUN groupadd -r appgroup && useradd -r -g appgroup appuser
#USER appuser

# Copy application files
COPY . ./

# Expose the application port
EXPOSE 4000

# Start the application
CMD ["npm", "run", "start"]

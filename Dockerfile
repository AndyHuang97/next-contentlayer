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
# Copy only necessary files from the build stage
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/.next ./.next

CMD ["npm", "run", "start"]

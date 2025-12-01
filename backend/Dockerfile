# Builder
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Runner
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production

# Some Permission Issue Fixe! Don't know what exactly
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Install only production dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy built assets from builder stage
COPY --from=builder /app/dist ./dist

# Change ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

EXPOSE 3847

CMD ["npm", "start"]
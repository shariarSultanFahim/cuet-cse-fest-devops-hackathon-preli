# Builder -- to compile TypeScript to JavaScript
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
# CI is clean install! but requires package-lock.json to be present, sorry for adding it to repository
RUN npm ci 
COPY . .
RUN npm run build

# Runner -- to run the compiled JavaScript code
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production

# Some Permission Issue Fixed! Don't know what exactly, something to do with Alpine Linux but I am on Windows
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Installing only production dependencies makes it optimized in my opinion
COPY package*.json ./
RUN npm ci --only=production

# Copy built assets from builder stage
COPY --from=builder /app/dist ./dist

RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 3847

CMD ["npm", "start"]
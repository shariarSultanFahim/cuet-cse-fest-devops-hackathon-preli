FROM node:18-alpine

WORKDIR /app
ENV NODE_ENV=production

# Some Permission Issue Fixed! Don't know what exactly, something to do with Alpine Linux but I am on Windows
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Installing only production dependencies makes it optimized in my opinion
COPY package*.json ./
RUN npm ci --only=production

COPY . .

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 5921

CMD ["npm", "start"]
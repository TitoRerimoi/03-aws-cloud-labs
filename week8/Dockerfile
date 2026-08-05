FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci
                  # Installs ALL deps including devDependencies
COPY . .

RUN npm run build

FROM node:18-alpine AS production

WORKDIR /app

EXPOSE 3001
CMD ["node", "dist/index.js"]

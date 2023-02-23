FROM node:18-alpine AS base

WORKDIR /app
RUN npm i -g pnpm
COPY pnpm-lock.yaml ./
RUN pnpm fetch

FROM base AS deploy

WORKDIR /app
COPY package.json index.js ./
RUN pnpm install --offline --prod

CMD ["node", "index.js"]
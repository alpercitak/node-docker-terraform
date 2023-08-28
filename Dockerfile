FROM node:18-alpine AS base

WORKDIR /app
RUN npm i -g pnpm
COPY package.json pnpm-lock.yaml ./
RUN pnpm fetch
RUN pnpm i --offline --prod

FROM node:18-alpine AS deploy

WORKDIR /app
COPY index.js ./
COPY --from=base ./app/package.json ./
COPY --from=base ./app/node_modules ./node_modules

CMD ["node", "index.js"]
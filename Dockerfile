# syntax=docker/dockerfile:1

FROM oven/bun:1 AS build
WORKDIR /app

# Only copy package.json so Bun generates a fresh, Linux-native install
COPY package.json ./
RUN bun install

COPY . .
RUN bun run build

FROM nginx:1.27-alpine AS runtime
WORKDIR /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist ./

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

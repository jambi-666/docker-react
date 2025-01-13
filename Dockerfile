FROM node:alpine as builder

WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run builder

FROM 3vilgenius/nginx-proxy
COPY --from=builder /app/build /usr/share/nginx/html
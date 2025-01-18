FROM node:alpine as builder

WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM 3vilgenius/nginx-proxy
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html
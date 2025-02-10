FROM node:22 AS node
WORKDIR /usr/src/app
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
RUN make build

FROM nginx AS server

EXPOSE 80

COPY --from=node /usr/src/app/dist /usr/share/nginx/html


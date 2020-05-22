FROM node:12.16.2-alpine3.11 as build
RUN apk --no-cache --update --virtual build-dependencies add \
    python \
    make \
    g++
WORKDIR /app
COPY package*.json ./
COPY yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build

FROM nginx:1.17.10-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/static.conf /etc/nginx/conf.d
COPY --from=build /app/build ./

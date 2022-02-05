FROM node:12 as builder
RUN apt-get update && apt-get install -y phantomjs
WORKDIR /app
COPY package*.json ./
RUN npm config set registry https://registry.npm.taobao.org
ENV QT_QPA_PLATFORM offscreen
RUN npm install
COPY . .
ARG API_URI
ARG SENTRY_DSN
ARG SENTRY_APM
ARG DEMO_MODE
ARG GTM_ID
ENV API_URI ${API_URI:-http://localhost:8000/graphql/}
RUN API_URI=${API_URI} npm run build:export

FROM nginx:stable
WORKDIR /app
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/ /app/

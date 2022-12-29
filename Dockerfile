FROM node:19.0.0-alpine@sha256:1a04e2ec39cc0c3a9657c1d6f8291ea2f5ccadf6ef4521dec946e522833e87ea
WORKDIR /src/
COPY ./themes/conventional-commits /src/
RUN apk add make
RUN npm install
RUN npm run build

FROM jguyomard/hugo-builder:latest@sha256:a9a13f8bffc59d10adf166b094313a417c8e4abe7021b1a34317e8f488945051
COPY ./ /src/
COPY --from=0 /src/ /src/themes/conventional-commits/
RUN hugo

FROM nginx:stable
COPY --from=1 /src/public/ /usr/share/nginx/html/
EXPOSE 80
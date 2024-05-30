FROM node:17.0-alpine3.14

WORKDIR /app

COPY package.json /

RUN apk update && \
    apk add --no-cache bash && \
    apk add --no-cache 'npm=7.17.0-r0' && \
    npm install

COPY app.js .

COPY index.pug favicon.ico ./views/

EXPOSE 80/tcp

CMD node app.js
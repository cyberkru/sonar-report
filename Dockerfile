FROM node:10-alpine

RUN apk update && apk add --no-cache bash curl

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./

USER node

RUN npm install

COPY --chown=node:node . ./

RUN chmod +x ./report.sh

CMD bash ./report.sh

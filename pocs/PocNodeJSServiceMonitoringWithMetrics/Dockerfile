FROM node:18-alpine

WORKDIR /usr/src/app
COPY package*.json ./

RUN apk --no-cache add bash
RUN apk --no-cache add make
RUN apk --no-cache add git
RUN apk --no-cache add curl

COPY . .
RUN make docker-prepare

EXPOSE 4000

ENTRYPOINT [ "npm", "run", "start:debug" ]

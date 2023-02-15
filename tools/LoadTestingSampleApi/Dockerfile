FROM node:18-alpine3.15

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

RUN npm install --quiet

# Copy app source
COPY . .

EXPOSE 8989

CMD [ "npm", "start" ]

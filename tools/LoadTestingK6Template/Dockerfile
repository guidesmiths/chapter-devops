FROM node:16-buster

RUN apt-get update && \
    apt-get install ca-certificates gnupg2 -y && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69 && \
    echo "deb https://dl.k6.io/deb stable main" | tee /etc/apt/sources.list.d/k6.list && \
    apt-get update && \
    apt-get install k6

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

# Install app dependencies
RUN npm install --quiet

# Bundle app source
COPY . .

# Avoid Container goes down
ENTRYPOINT ["tail", "-f", "/dev/null"]

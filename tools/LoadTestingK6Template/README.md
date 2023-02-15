# K6 Template Load Testing

This project pretend to simulate real stress situations for the production environment resources. This involves calling all the frontend available endpoints and measuring all the request metrics.

Take a look on the <a href="https://k6.io/docs/">k6 docs</a>

## Setup

Loading missing env vars.
```
touch .env && chmod +x .env
```
Append the following content to the `.env` file:
```
export TEST_URL=http://public-api-gateway-domain
```
Follow the output instructions from the command below
```
npm run set:unix:source:env
```

## Local usage

```
nvm use
```

```
npm install
```

```
npm start
```

# Development

## Create a test

After writting the new test make sure to append it on to the script located at `./bin/k6/run-dist.sh`. For that porpouse you will need to also add the new test on to the "_**entry:**_" section of file `webpack.config.js`

## Export new environment variable

Add you new environment variable to the `.env` file. Make sure to run the npm script _**set:unix:source:env**_ again. After that you just need to append the new variable name on to the "_**plugins**_:" section of file `webpack.config.js`

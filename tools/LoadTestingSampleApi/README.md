# Load testing sample API

## Introduction[![](./docs/img/pin.svg)](#introduction)

This project exposes a simple **_HTTP_ interface** on port `8989` that will be used in the POCs to compare different load testing frameworks.

This is the list of types of tests that can be performed:

* Main HTTP endpoint inmediately returning `status` 200 (OK)
* The behavior of the main endpoint can be modified so that it dynamically takes the choosed seconds to return a response based on the interests of the test

## &#128462; Docs

There is a graphical interface that will allow you to test the API locally. It's available on http://localhost:8989/docs/

## &#9889; Quick start

If you are currently using the same version than the one indicated in `.env` you can skip that step.
```
nvm use
```

Dependencies installation is done by using:
```
npm install
```

And you're ready to automatically start this project
```
npm start
```

In case you need to debug the application, this option would be valid for Linux and OS-X users:
```
DEBUG=*load-testing-sample-api* npm start
```

### &#128051; Docker-way to quick start

If you don't want to setup this project on to your system, you feel free to using our already build image:

```
npm run docker:start
```

In case you need to stop the container
```
npm run docker:stop
```

Other docker commands:
```bash
npm run docker:build
```
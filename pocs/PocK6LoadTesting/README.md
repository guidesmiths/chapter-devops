# K6 PoC

## Setup

Loading missing env vars.
```
touch .env && chmod +x .env
```
Append the following content to the `.env` file:
```
export TEST_URL=http://localhost:8989
```
Follow the output instructions from the command below
```
npm run set:unix:source:env
```

Run the sample API we will run our tests against.

Follow the instructions in https://gitlab.com/guidesmiths/chapters/devops/public-projects/load-testing-sample-api/container_registry to log in with Docker in Gitlab container registry. Then, run the image locally

```
docker run -dp 8989:8989 registry.gitlab.com/guidesmiths/chapters/devops/public-projects/load-testing-sample-api
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

## Tips

### Using Node.js libraries

Read that [document section](https://gitlab.com/guidesmiths/chapters/devops/public-projects/k6-load-testing-poc/-/tree/master#webpack-limitations) for understanding Webpack limitations.

```
// jwt-sign.js
const { sign } = require('jsonwebtoken');
require('dotenv').config();

const token = sign({ uuid, role }, process.env.JWT_SECRET);
console.log(token);
```
The script above would generate a valid token for being used during our k6 tests. That's the way for handling that value from the Webpack bundle:
```
JWT_TOKEN=$(node ./jwt-sign) webpack
```


## K6 Overview

Grafana k6 is an open-source load testing tool that makes performance testing easy and productive for engineering teams. k6 is free, developer-centric, and extensible.

Using k6, you can test the reliability and performance of your systems and catch performance regressions and problems earlier. k6 will help you to build resilient and performant applications that scale.

k6 is developed by [Grafana Labs](https://grafana.com/) and the community.

Its key features include:

- CLI tool with developer-friendly APIs.
- Scripting in JavaScript ES2015/ES6 - with support for local and remote modules
- Checks and Thresholds - for goal-oriented, automation-friendly load testing

## PoC Description

Since we can make use of a test api from which to simulate different scenarios for load tests, visualizing the use of K6 in a real project is much easier.
It makes use of the <a href="https://gitlab.com/guidesmiths/chapters/devops/public-projects/load-testing-sample-api">load-testing-sample-api</a> from which to simulate different scenarios for load tests, visualizing the use of K6 in a real project is much easier.
This API provides us scenario for us to force status errors in the responses and also simulate timeouts in the requests, simulating the behavior of an infrastructure that is no longer capable of supporting the load level required during a specific test.

To put ourselves in context this PoC contains three tests with different <a href="https://k6.io/docs/using-k6/checks/">checks</a>.
<br/>
(All these tests use the same <a href="https://k6.io/docs/using-k6/k6-options/">options</a> configured at `src/config/options.js`)

✅ <b>should not fail</b>
  - Perform a simple check to see if the response status is always `200`
    ```
    src/test/passing-test.js
    ```
❌ <b>should fail</b>
  - It performs exactly the same checks as the test described above, but in this case the test fails because the API is not returning a status `200`
    ```
    src/test/error-status-failing-test.js
    ```
  - It is also possible to check how long the responses are taking and what is the maximum time that we consider may not be adequate. In this case the options declare that <b>2 seconds is the maximum time</b>, but the endpoint of this test is <b>taking more than 3 seconds</b>
    ```
    src/test/timeout-failing-test.js
    ```

## Conclusions

### Webpack limitations

It is likely that since it is a framework with tests written in Javascript, the first thing that comes to mind is that they will be executed in [Node.js](https://nodejs.org/en/). However, our code in the tests will be compiled by [Webpack](https://webpack.js.org/), which will be in charge of generating a `build` that will be launched in the Javascript interpreter that Go has. This means that we will not be able to make use of native Node.js features during our tests.

One of the utilities that is missing a lot is the fact of not being able to access the [process.env](https://nodejs.org/dist/latest-v8.x/docs/api/process.html) at runtime, only at compile time. This means that the values of the environment variables will be saved with static values in the final `build` during compilation.

Sometimes we may need to generate a [JWT token](https://www.npmjs.com/package/jsonwebtoken) through its Node.js library to authenticate with an endpoint. This would be possible through the prior definition of an environment variable that is equivalent to the value that we want to obtain for the token.

Take a look at [this document section](https://gitlab.com/guidesmiths/chapters/devops/public-projects/k6-load-testing-poc/-/tree/master#conclusions) for better understanding.

### JS scripting

Although internally k6 is implemented in [Go](https://go.dev/) (to optimise performance), the tests are written in Javascript. This is a big advantage over other similar tools in most of the projects we work on, as we tend to use Javascript in both the back and the front end.

Writing simple tests with k6s knowing Javascript (and having a basic k6 configuration set up) is really simple. 
On the other hand, using k6 in .Net or Java projects can be more complex than using other tools, due to the fact that you have to get used to the JS syntax (although it is, in itself, quite simple).

### Cloud version

Among some of the main features of the cloud version of k6 that should be highlighted is the possibility of [premium visualization](https://k6.io/docs/cloud/analyzing-results/overview/) of the results. Whenever what is intended is to have an easy and fast way to view the results, this option can be interesting.

The rest of the premium options are nothing more than facilities when it comes to hosting and managing our tests.

For example, if we had the need to test a platform with resources deployed in different regions, the cloud version can deploy and run our tests from the location that we choose from the cloud panel.

Of course this is something that could be configured on our side to be deploy our CLI version in the region we choose.

### Cloud solution vs OSS

On the part of the K6 community they will always recommend the option of using their own cloud to launch the tests.

The problem is that running the tests with a basic environment of their cloud can become very expensive even for a simple project to test. That is why from the DevOps chapter we recommend running the OSS version.

There are multiple options to run the OSS version tests. One of these options would be to run the tests from the [integration offered with Kubernetes](https://k6.io/blog/running-distributed-tests-on-k8s/).

Of course, the most **classic option** can be considered, which would be to configure a **virtual machine** with a [Docker](https://www.docker.com/) instance configured on it. Since there is an official [K6 Docker image](https://hub.docker.com/r/loadimpact/k6) we can _dockerize_ our tests based on this image. In this way, the image that we generate could be launched in this dedicated virtual machine in a very **similar way to the cloud environment** but without having as many features.

Definitely this last option would be the one that we would have to opt for **in general for most projects**. Either because of the **low complexity** involved in setting up this environment and its **low cost**, these two factors are key to deciding to run our tests using this option.

### Test output

Regarding the test output, the on-premise version of k6s does not provide much information about the status of the tests during their execution, it simply shows a [progress bar in the CLI](https://k6.io/docs/results-visualization/end-of-test-summary/#the-default-summary), and the number of VUs (virtual users) currently in use.
The [cloud](https://k6.io/cloud/) version, however, does provide charts with the live status of the tests.

At the end of the test, k6 returns a table with a very complete set of test metrics, as well as its result (pass or fail). These metrics can be [extended and customized](https://k6.io/docs/results-visualization/end-of-test-summary/#customize-with-handlesummary).

Test results can be easily exported and imported into multiple metrics visualisation platforms (CloudWatch, Grafana, Prometheus, New Relic, etc.).
This can serve as an alternative to see graphically the behaviour of different metrics during the execution of the tests (which is not possible to see live if we run them on-premise).

### Evaluate expected

The [checks](https://k6.io/docs/using-k6/checks/) are nothing more than methods provided by the k6 libraries to evaluate the test results and determine if it is a failed test or not. 

The checks that can be found natively are more than enough for most use cases. However, expanding our range of possibilities by creating check cutsoms is an easy task. All we need to do is create a function that evaluates our desired parameters in the response and throws a `throw` if the conditions are not met.

This is something that is not an easy task or even a possibility that exists in other load testing frameworks.

### Open Source

K6 is owned by [Grafana](https://go2.grafana.com/grafana-cloud.html?src=ggl-s&mdm=cpc&camp=b-grafana-exac-emea&cnt=118483912276&trm=grafana&device=c&gclid=CjwKCAjwrNmWBhA4EiwAHbjEQHn4trEQmXg4sNL7rTmbou9lOqDvuNQCSJy4yH2Urjk6L20BcR9xhhoC0ZoQAvD_BwE) Labs but is an open source project maintained by both this organisation and the community. This makes it a living project, constantly evolving and with multiple extensions made by the community.

In addition, it is possible to create new extensions to adapt k6s to particular use cases (although this requires knowledge of Go).

### Fault detection

Since the possibility of a test failing is entirely possible, we can detect this scenario very easily.

Every process that is launched on a system starts and ends returning an [exit code](https://shapeshed.com/unix-exit-codes/) that is generated on completion. In short, any status other than 0 will be detected as an error by our prompt, interrupting the process.

This is comparable to our tests being executed inside the `k6` command to run our tests via CLI. If one of our tests fails, this command will throw an exit code 127, causing the command to show the `check` of the test that failed and also end the rest of the tests without evaluating more results.

This makes integrating the CLI version with our custom pipelines a really easy task.

### Stress Level Customization

The stress level generated by the tests is easily [customizable](https://k6.io/docs/test-types/introduction/). K6 use VUs or virtual users that will execute the test script concurrently as the metric to adjust the stress level of the test.

The configuration of the stress levels are divided into phases, each with a number of VUs and a time duration of the phase.
The phases are executed sequentially and the test is terminated when all phases have been executed.

Different stress level settings can be defined, so that different tests can be run with different config or even the same test can be run with different config.

Basic example of stress level configuration with two phases:
- Phase 1 of 5 minutes duration with 15 VUs (concurrent users).
- Phase 2 of 2 minutes duration with 30 VUs.

### Using not suported protocols

In the event that the technology we need to test is not officially supported by k6, there is always the option of creating our own [extensions](https://k6.io/docs/extensions/).

[Kafka](https://www.google.com/aclk?sa=l&ai=DChcSEwiPydv6yJ35AhUWndUKHcH1CaEYABACGgJ3cw&ae=2&sig=AOD64_11bvZT91D5byyYlEr9xzZrpw7v-w&adurl&ved=2ahUKEwiS1tT6yJ35AhVS2xoKHQWID-kQqyQoAHoECAMQBQ) (distributed streaming system) is currently officially supported. This means that we would not have to do more than guide ourselves in the [documentation](https://k6.io/docs/results-visualization/apache-kafka/) to create our tests.

What if this time we needed to test [RabbitMQ](https://www.rabbitmq.com/) instead? Fortunately there is an [extension](https://github.com/grafana/xk6-kubernetes) that is not yet implemented in the K6 core.

However, we have to be aware that **all external extensions** will warn us that they **may break in the course of K6 development**. So we have to be clear that the extensions that we are going to use must be minimally maintained. This is under our responsibility.

In the opinion of the DevOps chapter we **always prefer to use K6 core extensions** (available from the official documentation). Since maintaining **external functionalities can cost us a lot of time** in the case that we have problems in the future using an extension that has become **incompatible with the new features of K6**.

## Bullet points

PROS:
  - Official _**docs**_ are **not extensive** for new users but really **well explained**.
  - We have many ready-made implementations to communicate with the different data visualization tools.
  - Since the tests are written in **Javascript** having **prior language knowledge** will make it **easier for us to adapt**.
  - Very **low costs** even for extensive tests.
  - **Other companies** make it **difficult to use OSS** for you to contract their already configured payment cloud services but for this case **self hosting** is **not difficult**.
  - **Test output** can be easily exported to multiple 3rd party services (CloudWatch, Grafana, Prometheus, New Relic, etc).
  - Multiple **assertions** (checks) and possibility to create customise ones.

CONS:
  - Creating extensions is not an easy job. The community extensions are not actively maintained.
  - Still **missing** to implement some of the most used **protocols**.
  - Cloud is really expensive even for the most simple testing plan.
  - Coding that kind of tests is not difficult but if we don't know how to code **Javascript** it will be an added **initial barrier**.
  - **NodeJS** libraries are **not compatible** since Webpack is being used for compilations.
  - If we do **not have Clouds knowledge**, we need to contract the already configured cloud version with its **corresponding costs**.
  - It does not provide **test output** during test execution (only available with the cloud version).

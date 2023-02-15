const express = require('express');
const debug = require('debug');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const { setTimeout } = require('timers/promises');

const config = require('./config');

const debugRootEndpoint = debug('load-testing-sample-api:root-endpoint');
const debugHttpServer = debug('load-testing-sample-api:http-server');

const httpServer = express();

/**
 * @openapi
 * /:
 *  get:
 *    description: Root endpoint for dynamic load tests examples
 *    parameters:
 *      - in: query
 *        name: timeoutSeconds
 *        schema:
 *          type: integer
 *          required: false
 *          description: Amount of seconds that the endpoint should delay any response
 *    responses:
 *      200:
 *        description: API is  running
 */
httpServer.get('/', async (request, response) => {
  debugRootEndpoint(`Processing request from ${request.hostname}`);
  const { status = 200, timeoutSeconds } = request.query;
  if (timeoutSeconds) {
    debugRootEndpoint(`Waiting ${timeoutSeconds} seconds before answering ...`);
    await setTimeout(+timeoutSeconds * 1000);
  }
  return response.status(status).json();
});

// Swagger docs
const swaggerSpec = swaggerJsdoc(config.swagger);
httpServer.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Listen for http requests
const httpServerListener = httpServer.listen(config.httpServer.port, () => {
  debugHttpServer(`App listening on port ${config.httpServer.port}`);
});

module.exports = {
  httpServer,
  closeHttpServer: () => httpServerListener.close(),
};

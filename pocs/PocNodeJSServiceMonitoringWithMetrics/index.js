const debug = require('debug')('testing');
const express = require('express');

const promClient = require('prom-client');

const { collectDefaultMetrics, Gauge, register } = promClient;

collectDefaultMetrics();

const requestTimeMetric = new Gauge({
  name: 'testmetric_request_time',
  help: 'Test metric about request time',
  labelNames: ['code'],
});

const app = express();
const servicePort = process.env.SERVICE_PORT || 4000;
require('dotenv').config();

app.get('/metrics', async (req, res) => {
  debug('Requesting metrics');
  const metrics = await register.metrics();
  res.send(metrics);
});

app.listen(servicePort, () => {
  debug(`Application started on port ${servicePort}`);
});

const generateSomeMetrics = async () => {
  debug('Generating some metrics, from pokemon API :)');
  setTimeout(generateSomeMetrics, 15000);
  const requestExecutionTime = process.hrtime();

  const fakerequest = await fetch('https://pokeapi.co/api/v2/pokemon/');
  const elapsedMs = process.hrtime(requestExecutionTime)[1] / 1000000;
  requestTimeMetric.set({ code: fakerequest.status }, elapsedMs);
};

setTimeout(generateSomeMetrics, 15000);

// Modules
const { sleep, check } = require('k6');
const http = require('k6/http');
const { Rate } = require('k6/metrics');

// Config
const { testTypes } = require('../config/options.js');
const { appendAdditionalOptions } = require('../config/utils.js');

// Definitions
export const errorRate = new Rate('errors');

// Scenario
export const options = appendAdditionalOptions({
  stages: testTypes.smoke,
});

// Test
export default () => {
  const statusCode = 502;
  const response = http.get(`${process.env.TEST_URL}/?status=${statusCode}`);
  const checkResult = check(response, { 'status was 200': ({ status }) => status === 200 });
  errorRate.add(!checkResult);
  sleep(1);
};

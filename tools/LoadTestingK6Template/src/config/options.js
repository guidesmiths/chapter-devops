/**
 * Using the default "k6 run" options the environment variables will be overwritten over
 * the avove exported options.
 * Take a look on the docs to overwrite this options:
 * https://k6.io/docs/using-k6/environment-variables/#accessing-environment-variables-from-a-script
 * https://k6.io/docs/using-k6/execution-context-variables/
 */
export const defaultOptions = {
  thresholds: {
    // <1% errors
    errors: ['rate<0.1'],
    // 90% of requests must finish within 2 seconds.
    http_req_duration: ['p(90) < 2000'],
  },
  noConnectionReuse: true,
  userAgent: 'MyK6UserAgentString/1.0',
};

/**
 * This graph perfectly explains the context for each test type:
 * https://k6.io/docs/test-types/introduction/
 */
export const testTypes = {
  smoke: [
    { duration: '10s', target: 1 },// 1 user looping for 10s
  ],
  load: [
    { duration: '2m', target: 10 }, // simulate ramp-up of traffic from 1 to 10 users over 2 minutes.
    { duration: '4m', target: 30 }, // stay at 30 users for 4 minutes
    { duration: '1m', target: 5 }, // ramp-down to 5 users
  ],
  stress: [
    { duration: '2m', target: 30 }, // below normal load
    { duration: '4m', target: 30 },
    { duration: '2m', target: 50 }, // normal normal load
    { duration: '4m', target: 50 },
    { duration: '2m', target: 80 }, // around the breaking point
    { duration: '4m', target: 80 },
    { duration: '2m', target: 100 }, // beyond the breaking point
    { duration: '4m', target: 100 },
    { duration: '5m', target: 0 }, // scale down. Recovery stage
  ],
  soak: [
    { duration: '5m', target: 200 }, // ramp up to 200 users
    { duration: '3h56m', target: 200 }, // stay at 200 for ~4 hours
    { duration: '2m', target: 0 }, // scale down. (optional)
  ],
};

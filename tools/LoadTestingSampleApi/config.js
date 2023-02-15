module.exports = {
  httpServer: {
    port: 8989,
  },
  swagger: {
    definition: {
      openapi: '3.0.0',
      info: {
        title: 'Sample load testing API',
        description: 'Load testing frameworks POCs can point this API',
        version: '1.0.0',
      },
    },
    apis: ['./index.js'],
  },
};

const supertest = require('supertest');
const { StatusCodes } = require('http-status-codes');
const { performance } = require('perf_hooks');
const { httpServer, closeHttpServer } = require('../index');

describe('Http API calls', () => {
  const constants = {};
  beforeAll(() => {
    constants.httpServer = supertest(httpServer);
  });

  afterAll(() => closeHttpServer());

  describe('/', () => {
    describe('get', () => {
      describe('should not fail', () => {
        it('should return OK (200)', async () => {
          const initialPerformanceTime = performance.now();
          const { status } = await constants.httpServer.get('/');
          const requestTotalTime = performance.now() - initialPerformanceTime;
          expect(status).toBe(StatusCodes.OK);
          expect(requestTotalTime).toBeLessThan(1_000);
        });

        it('should return OK (200) with a response delay', async () => {
          const initialPerformanceTime = performance.now();
          const { status } = await constants.httpServer.get('/?timeoutSeconds=2');
          const requestTotalTime = performance.now() - initialPerformanceTime;
          expect(status).toBe(StatusCodes.OK);
          expect(requestTotalTime).toBeGreaterThanOrEqual(2_000);
          expect(requestTotalTime).toBeLessThan(3_000);
        });

        it('should return 502 (BAD_GATEWAY) from the desired status', async () => {
          const initialPerformanceTime = performance.now();
          const { status } = await constants.httpServer.get('/?status=502');
          const requestTotalTime = performance.now() - initialPerformanceTime;
          expect(status).toBe(StatusCodes.BAD_GATEWAY);
          expect(requestTotalTime).toBeGreaterThanOrEqual(0);
          expect(requestTotalTime).toBeLessThan(1_000);
        });
      });
    });
  });

  describe('/docs', () => {
    describe('get', () => {
      it('should return OK (200)', async () => {
        const { status } = await constants.httpServer.get('/docs/');
        expect(status).toBe(StatusCodes.OK);
      });

      it('should return MOVED_PERMANENTLY (301)', async () => {
        const { status } = await constants.httpServer.get('/docs');
        expect(status).toBe(StatusCodes.MOVED_PERMANENTLY);
      });
    });
  });
});

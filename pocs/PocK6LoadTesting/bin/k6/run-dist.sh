#!/bin/sh
k6 run ./dist/passing-test.bundle.js
k6 run ./dist/timeout-failing-test.bundle.js
k6 run ./dist/error-status-failing-test.bundle.js

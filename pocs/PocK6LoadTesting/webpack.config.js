const path = require('path');
const { EnvironmentPlugin } = require('webpack');

module.exports = {
  // For reading the bundle in order to debug, modify the value for "development"
  mode: 'production',
  entry: {
    'passing-test': './src/test/passing-test.js',
    'timeout-failing-test': './src/test/timeout-failing-test.js',
    'error-status-failing-test': './src/test/error-status-failing-test.js',
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    libraryTarget: 'commonjs',
    filename: '[name].bundle.js',
  },
  module: {
    rules: [{ test: /\.js$/, use: 'babel-loader' }],
  },
  plugins: [
    new EnvironmentPlugin(['TEST_URL']),
  ],
  target: 'web',
  externals: /k6(\/.*)?/,
};

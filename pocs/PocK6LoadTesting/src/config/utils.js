// Modules
const { merge } = require('webpack-merge');
// Config
const { defaultOptions } = require('./options.js');

function appendAdditionalOptions(params) {
  const options = merge(defaultOptions, params);
  return options;
}

module.exports = {
  appendAdditionalOptions,
};

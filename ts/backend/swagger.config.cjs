const { version } = require('./package.json')

module.exports = {
  openapi: '3.0.0',
  info: {
    title: 'FAB Client Lib',
    version,
    description: 'Python client lib to access Flatland Association Benchmarks / AI4REALNET Campaign Hub Backend API, generated with openapi-generator',
  }
}

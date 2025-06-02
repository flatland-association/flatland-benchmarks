const { version } = require('./package.json')

module.exports = {
  openapi: '3.0.0',
  info: {
    title: 'FAB backend',
    version,
    description: 'FAB backend API',
  }
}

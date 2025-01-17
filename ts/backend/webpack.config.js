const path = require('path');
const nodeExternals = require('webpack-node-externals');

module.exports = {
  entry: '../../out-tsc/backend-build/backend/src/app/main.mjs',
  // ignore node built-ins
  target: 'node',
  // ignore node_modules (express has to be listed separately for some reason)
  externals: [nodeExternals(), {'express': 'commonjs express'}],
  output: {
    path: path.resolve(__dirname, '../../out-tsc/backend-build/app'),
    filename: 'main.min.js',
  },
  optimization: {
    minimize: true,
  },
  // mode: 'development'
  mode: 'production',
  resolve: {
    preferRelative: true
  }
};
// TODO: find out why VSCode won't lint backend without this file

// @ts-check
const tseslint = require("typescript-eslint");
const rootConfig = require("../../eslint.config.js");

module.exports = tseslint.config(
  ...rootConfig,
  // Per default, **/*.js, **/*.cjs, and **/*.mjs are always matched unless
  // globally ignored. Thus, globally ignore coverage, where auto-generated .js
  // files live:
  // https://eslint.org/docs/latest/use/configure/configuration-files#:~:text=By%20default%2C%20ESLint%20lints%20files%20that%20match%20the%20patterns%20**/*.js%2C%20**/*.cjs%2C%20and%20**/*.mjs.%20Those%20files%20are%20always%20matched%20unless%20you%20explicitly%20exclude%20them%20using%20global%20ignores.
  {
    ignores: ['test/coverage/**']
  }
);

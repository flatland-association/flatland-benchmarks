// @ts-check
const tseslint = require("typescript-eslint");
const rootConfig = require("../../eslint.config.js");
const angular = require("angular-eslint");

module.exports = tseslint.config(
  ...rootConfig,
  {
    files: ["**/*.ts"],
    extends: [
      ...angular.configs.tsRecommended,
    ],
    processor: angular.processInlineTemplates,
    rules: {
      "@angular-eslint/directive-selector": [
        "error",
        {
          type: "attribute",
          prefix: "app",
          style: "camelCase",
        },
      ],
      "@angular-eslint/component-selector": [
        "error",
        {
          type: "element",
          prefix: ["app", "view"],
          style: "kebab-case",
        },
      ],
      "@angular-eslint/component-class-suffix": [
        "error",
        {
          suffixes: [
            "Component",
            "View"
          ]
        }
      ],
    },
  },
  {
    files: ["**/*.html"],
    extends: [
      ...angular.configs.templateRecommended,
      ...angular.configs.templateAccessibility,
    ],
    rules: {},
  }
);

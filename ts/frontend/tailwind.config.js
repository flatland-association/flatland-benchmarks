const { theme: baseTheme } = require('../../node_modules/@flatland-association/flatland-ui/tailwind.config')

/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [require('../../node_modules/@flatland-association/flatland-ui/tailwind.config')],
  // relative to where the project's `package.json` sits
  content: ['../../node_modules/@flatland-association/flatland-ui/**/*.mjs', './src/**/*.{html,ts}'],
  theme: {
    extend: {
      colors: {
        primary: baseTheme.colors.neutral,
        gradientFrom: baseTheme.colors.neutral['400'],
        gradientTo: baseTheme.colors.neutral['600'],
      },
    },
  },
  plugins: [],
}

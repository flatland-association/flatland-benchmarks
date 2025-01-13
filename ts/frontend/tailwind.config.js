const { theme: baseTheme } = require('../../node_modules/@flatland-association/flatland-ui/tailwind.config')

/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [require('../../node_modules/@flatland-association/flatland-ui/tailwind.config')],
  // relative to where the project's `package.json` sits
  content: ['../../node_modules/@flatland-association/flatland-ui/**/*.mjs', './src/**/*.{html,ts}'],
  theme: {
    extend: {
      colors: {
        primary: baseTheme.colors.turquoise,
        gradientFrom: baseTheme.colors.turquoiseBright['500'],
        gradientTo: baseTheme.colors.turquoise['600'],
      },
    },
  },
  plugins: [],
}

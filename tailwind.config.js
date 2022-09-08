/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.elm"],
  theme: {
    fontFamily: {
      sans: ["Inter", "ui-sans-serif", "system-ui", "sans-serif"],
      mono: ["Roboto Mono", "ui-monospace", "monospace"],
    },
    extend: {
      colors: {
        'elm-blue': '#1293d8',
      }
    }
  },
  plugins: [],
}

module.exports = {
  purge: [],
  theme: {
    extend: {
      colors: {
        "elm-blue": "#1293d8"
      },
      spacing: {
        "2px": "2px"
      }
    }
  },
  variants: {
    backgroundColor: ["responsive", "hover", "focus", "focus-within"],
    boxShadow: ["responsive", "hover", "focus", "focus-within"]
  },
  plugins: []
}

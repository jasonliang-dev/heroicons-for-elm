const defaultConfig = require("tailwindcss/defaultTheme")

module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true
  },
  purge: ["./src/**/*.elm"],
  theme: {
    extend: {
      colors: {
        "elm-blue": "#1293d8",
        blue: {
          ...defaultConfig.colors.blue,
          450: "#4CA9EC"
        }
      },
      spacing: {
        "2px": "2px"
      }
    }
  },
  variants: {
    textColor: ["responsive", "hover", "focus", "group-hover"],
    backgroundColor: ["responsive", "hover", "focus", "focus-within"],
    boxShadow: ["responsive", "hover", "focus", "focus-within"]
  },
  plugins: []
}

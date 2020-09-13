const merge = require("webpack-merge")

module.exports = {
  homepage: "https://jasonliang512.github.io/heroicons-for-elm",
  configureWebpack: (config, env) => {
    return merge(config, {
      module: {
        rules: [
          {
            test: /\.css/,
            use: [
              {
                loader: require.resolve("postcss-loader"),
                options: {
                  plugins: () => [require("tailwindcss")]
                }
              }
            ]
          },
          {
            test: /\.yaml$/,
            loader: "raw-loader"
          }
        ]
      }
    })
  }
}

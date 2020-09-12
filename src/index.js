import "highlight.js/styles/atom-one-dark.css"
import "tippy.js/dist/tippy.css"
import "tippy.js/animations/shift-away.css"
import "./main.css"
import { Elm } from "./Main.elm"
import * as serviceWorker from "./serviceWorker"
import copy from "copy-to-clipboard"
import hljs from "highlight.js/lib/core"
import highlightElm from "highlight.js/lib/languages/elm"
import tippy from "tippy.js"

hljs.registerLanguage("elm", highlightElm)

const requestAnimationFrame =
  window.requestAnimationFrame ||
  window.mozRequestAnimationFrame ||
  window.webkitRequestAnimationFrame ||
  window.msRequestAnimationFrame

const app = Elm.Main.init({
  node: document.getElementById("root")
})

serviceWorker.unregister()

app.ports.iconCodeChange.subscribe(function () {
  /*
  requestAnimationFrame(function () {
    document.querySelectorAll("pre code").forEach((block) => {
      hljs.highlightBlock(block)
    })
  })
  */
})

app.ports.copy.subscribe(function (text) {
  copy(text, { format: "text/plain" })
})

let tooltip

app.ports.makeTippy.subscribe(function (content) {
  requestAnimationFrame(function () {
    tooltip = tippy("[data-tippy]", {
      content,
      hideOnClick: false,
      placement: "bottom",
      animation: "shift-away",
      theme: "tailwind"
    })[0]
  })
})

app.ports.setTippyContent.subscribe(function (content) {
  if (tooltip) {
    tooltip.setContent(content)
  } else {
    console.error("Cannot set tooltip content from value: ", tooltip)
  }
})

app.ports.freeTippy.subscribe(function () {
  if (tooltip) {
    tooltip.destroy()
  } else {
    console.error("Cannot destory tooltip from value: ", tooltip)
  }
})

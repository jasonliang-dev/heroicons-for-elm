@echo off

robocopy static dist /E
robocopy resources dist/resources /E
tailwindcss -i src/style.css -o dist/style.css
elm make src/Main.elm --optimize --output=dist/main.js

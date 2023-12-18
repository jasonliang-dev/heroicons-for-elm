@echo off

robocopy public dist /njh /njs /ndl /nc /ns
tailwindcss -i src/style.css -o dist/style.css
elm make src/Main.elm --output=dist/main.js
REM elm make src/Main.elm --optimize --output=dist/main.js

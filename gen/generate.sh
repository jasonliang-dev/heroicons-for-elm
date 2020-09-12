#/usr/bin/env bash

python3 generate_module.py Outline heroicons/optimized/outline/*.svg
python3 generate_module.py Solid heroicons/optimized/solid/*.svg

elm-format $PWD/ --yes
mv *.elm $PWD/../src/Gallery

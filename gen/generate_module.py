import sys
import json
import xml.etree.ElementTree as ET

from create_elm_icon import to_elm_icon

with open("tags.json", "r") as file_in:
    tags = json.load(file_in)

ET.register_namespace("", "http://www.w3.org/2000/svg")
icons = ",\n".join(map(lambda i: to_elm_icon(tags, i), sys.argv[2:]))

source_code = f"""module Gallery.{sys.argv[1]} exposing (model)

import Heroicons.{sys.argv[1]} exposing (..)
import Gallery exposing (Icon, XMLTree(..))


model : List (Icon a)
model = [{icons}]
"""

with open(f"{sys.argv[1]}.elm", "w") as file_out:
    file_out.write(source_code)

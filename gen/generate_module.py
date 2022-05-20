import base64
import copy
import json
import os.path
import sys
import xml.etree.ElementTree as ET

from attr_lookup import svg_attrs


def to_elm_xml_tree(node):
    _, tag = node.tag[1:].split("}")  # strip namespace

    attrs = []
    for name, value in node.attrib.items():
        name = svg_attrs.get(name, name)
        if name != "aria-hidden":
            attrs.append(f'("{name}", "{value}")')

    attrs = ",".join(attrs)
    children = ",\n".join(map(to_elm_xml_tree, node))

    return (
        "XmlTree {\n"
        f'    tag = "{tag}",\n'
        f"    attributes = [{attrs}],\n"
        f"    children = [{children}]\n"
        "}"
    )


def to_elm_icon(tag_lookup, svg_file):
    # icon name in camel-case
    file_name = os.path.basename(svg_file).replace(".svg", "")
    firstWord, *rest = file_name.split("-")
    icon_name = firstWord + "".join(word.capitalize() for word in rest)

    # icon tags for search
    tags = tag_lookup.get(file_name, [])
    tags = map(lambda t: f'"{t}"', tags)
    tags = ", ".join(tags)

    # icon xml tree
    tree = ET.parse(svg_file)
    elm_xml_tree = to_elm_xml_tree(tree.getroot())

    return f'{{ name = "{file_name}", tags = [{tags}], viewIcon = {icon_name}, tree = {elm_xml_tree} }}'


with open("tags.json", "r") as file_in:
    tags = json.load(file_in)

ET.register_namespace("", "http://www.w3.org/2000/svg")
icons = ",\n".join(map(lambda i: to_elm_icon(tags, i), sys.argv[2:]))

source_code = f"""module Gallery.{sys.argv[1]} exposing (model)

import Heroicons.{sys.argv[1]} exposing (..)
import Gallery exposing (Icon, XmlTree(..))


model : List (Icon a)
model = [{icons}]
"""

with open(f"{sys.argv[1]}.elm", "w") as file_out:
    file_out.write(source_code)

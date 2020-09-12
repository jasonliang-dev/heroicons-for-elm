import base64
import copy
import os.path
import sys
import xml.etree.ElementTree as ET

from attr_lookup import svg_attrs

def to_attr(xml_attr):
    name, value = xml_attr
    attr = svg_attrs.get(name, name)

    return f'("{attr}", "{value}")'


def to_elm_xml_tree(node):
    _, tag = node.tag[1:].split("}")  # strip namespace
    attrs = ", ".join(map(to_attr, node.attrib.items()))
    children = ",\n".join(map(to_elm_xml_tree, node))

    return (
        "XMLTree {\n"
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

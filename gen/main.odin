package main

import "core:c/libc"
import "core:encoding/base64"
import "core:encoding/xml"
import "core:fmt"
import "core:io"
import "core:os"
import "core:strings"

to_elm :: proc(buf: ^strings.Builder, doc: ^xml.Document, id: xml.Element_ID) {
	el := doc.elements[id]

	fmt.sbprintf(buf, "Svg.%v [ ", el.ident)

	i := 0
	for attr in el.attribs {
		if attr.key == "xmlns" || attr.key == "aria-hidden" {
			continue
		}

		if i > 0 {
			strings.write_string(buf, ", ")
		}

		fmt.sbprintf(buf, `Svg.Attributes.%v "%v"`, attrs[attr.key], attr.val)

		i += 1
	}

	strings.write_string(buf, " ] [ ")

	for child_id, i in el.children {
		if i > 0 {
			strings.write_string(buf, ", ")
		}

		to_elm(buf, doc, child_id)
	}

	strings.write_string(buf, " ]")
}

to_tree :: proc(buf: ^strings.Builder, doc: ^xml.Document, id: xml.Element_ID) {
	el := doc.elements[id]

	fmt.sbprintf(buf, "XmlTree {{\n tag = \"%v\"\n , attributes = [", el.ident)

	i := 0
	for attr in el.attribs {
		if attr.key == "xmlns" || attr.key == "aria-hidden" {
			continue
		}

		if i > 0 {
			strings.write_string(buf, ", ")
		}

		fmt.sbprintf(buf, `("%v", "%v")`, attrs[attr.key], attr.val)

		i += 1
	}

	fmt.sbprintf(buf, "]\n , children = [")

	for child_id, i in el.children {
		if i > 0 {
			strings.write_string(buf, "\n , ")
		}

		to_tree(buf, doc, child_id)
	}

	strings.write_string(buf, `]}`)
}

generate :: proc(builder: ^strings.Builder, path: string, module: string, outfile: string) {
	fmt.printf("generating %v...", outfile)
	defer fmt.println(" done.")

	dir, err := os.open(path)
	defer os.close(dir)
	if err != 0 {
		fmt.eprintf("cannot open directory %v, (errno %v)\n", path, err)
		os.exit(1)
	}

	infos: []os.File_Info
	infos, err = os.read_dir(dir, 0)
	defer delete(infos)
	if err != 0 {
		fmt.eprintf("cannot read directory (errno %v)\n", err)
		os.exit(1)
	}

	fmt.sbprintf(builder, `module Gallery.%[1]v exposing (model)

import Gallery exposing (Icon, XmlTree(..))
import Html exposing (Html)
import Svg exposing (Attribute)
import Svg.Attributes

model : List (Icon a)
model = [`, module)

	for info, i in infos {
		if i > 0 {
			strings.write_string(builder, "\n ,")
		}

		doc, err := xml.load_from_file(info.fullpath)
		defer xml.destroy(doc)
		if err != .None {
			fmt.eprintf("cannot load file: %v\n", err)
			os.exit(1)
		}

		file_name := strings.trim_suffix(info.name, ".svg")
		icon_name := strings.to_camel_case(file_name, context.temp_allocator)

		fmt.sbprintf(builder, "{{ name = \"%v\"\n , tags = [", file_name)

		icon_tags, ok := tags[file_name]
		if ok {
			for tag, i in icon_tags {
				if i > 0 {
					strings.write_string(builder, ", ")
				}

				fmt.sbprintf(builder, `"%v"`, tag)
			}
		}

		strings.write_string(builder, "]\n , viewIcon = ")
		to_elm(builder, doc, 0)
		fmt.sbprintf(builder, ", tree = ")
		to_tree(builder, doc, 0)
		strings.write_string(builder, "\n }")
	}

	strings.write_string(builder, "]")

	ok := os.write_entire_file(outfile, builder.buf[:])
	if !ok {
		fmt.eprintf("cannot write file contents to %v\n", outfile)
		os.exit(1)
	}

	strings.builder_reset(builder)
}

main :: proc() {
	file_builder := strings.builder_make()
	defer strings.builder_destroy(&file_builder)

	generate(&file_builder, "heroicons/optimized/24/solid", "Solid", "../src/Gallery/Solid.elm")
	generate(&file_builder, "heroicons/optimized/24/outline", "Outline", "../src/Gallery/Outline.elm")
	generate(&file_builder, "heroicons/optimized/20/solid", "Mini", "../src/Gallery/Mini.elm")

	libc.system("elm-format ../src/Gallery/ --yes")
}
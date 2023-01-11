extends Node

var _tag_res: Resource = preload("res://ui/component/tag.tscn")


func create_tag(tag: String) -> Control:
	var tag_element: Control = _tag_res.instance()
	tag_element.set_text(tag)
	return tag_element

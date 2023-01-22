extends ColorRect

var _tag_key: String
var _ui_node: Control

onready var _label_desc: Label = $CC/PC/VC/LabelDesc


func _ready() -> void:
	var tag_name: String = Data.get_tag_by_key(_tag_key)
	_label_desc.text = _label_desc.text % tag_name


func setup(tag_key: String, ui_node: Control) -> void:
	_tag_key = tag_key
	_ui_node = ui_node


func _on_ButtonDelete_pressed() -> void:
	Data.delete_tag(_tag_key)
	_ui_node.queue_free()
	queue_free()


func _on_ButtonCancel_pressed() -> void:
	queue_free()

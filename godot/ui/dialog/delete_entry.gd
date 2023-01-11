extends ColorRect

var _entry_name: String

onready var _label_desc: Label = $CC/PC/VC/LabelDesc


func _ready() -> void:
	_label_desc.text = _label_desc.text % _entry_name


func set_entry_name(entry_name: String) -> void:
	_entry_name = entry_name


func _on_ButtonDelete_pressed() -> void:
	Data.delete_entry()
	queue_free()


func _on_ButtonCancel_pressed() -> void:
	queue_free()

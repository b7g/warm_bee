extends ColorRect

var _collection_name: String

onready var _label_desc: Label = $CC/PC/VC/LabelDesc


func _ready() -> void:
	_label_desc.text = _label_desc.text % _collection_name


func set_collection_name(collection_name: String) -> void:
	_collection_name = collection_name


func _on_ButtonDelete_pressed() -> void:
	Data.delete_collection()
	queue_free()


func _on_ButtonCancel_pressed() -> void:
	queue_free()

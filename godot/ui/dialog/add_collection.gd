extends Control

onready var _txt_collection_name: LineEdit = $CC/PC/VC/VC/LineEditName
onready var _btn_create: Button = $CC/PC/VC/HC/ButtonCreate


func _ready() -> void:
	_txt_collection_name.grab_focus()


func _on_LineEditName_text_changed(new_text: String) -> void:
	_btn_create.disabled = new_text.empty()


func _on_ButtonCreate_pressed() -> void:
	var collection_name: String = _txt_collection_name.text
	if collection_name.empty():
		return
	Data.create_collection(collection_name)
	queue_free()


func _on_ButtonCancel_pressed() -> void:
	queue_free()

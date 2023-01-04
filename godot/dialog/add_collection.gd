extends Control

var _main: Control

onready var _txt_collection_name: LineEdit = $CC/VC/LineEditName
onready var _btn_create: Button = $CC/VC/ButtonCreate


func _ready() -> void:
	_txt_collection_name.grab_focus()


func set_main_ref(main: Control) -> void:
	_main = main


func _on_LineEditName_text_changed(new_text: String) -> void:
	_btn_create.disabled = new_text.empty()


func _on_ButtonCreate_pressed() -> void:
	var collection_name: String = _txt_collection_name.text
	if collection_name.empty():
		return
	Data.create_collection(collection_name)
	queue_free()


func _on_ButtonClose_pressed() -> void:
	queue_free()

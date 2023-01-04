extends Control

var _main: Control

onready var _txt_collection_name: LineEdit = $VC/LineEditName
onready var _opt_collection_type: OptionButton = $VC/HC/OptionButtonType
onready var _btn_create: Button = $VC/ButtonCreate


func _ready() -> void:
	for type_id in Structure.get_collection_types().size():
		_opt_collection_type.add_item(Structure.get_collection_type_display_names()[type_id])
	_txt_collection_name.grab_focus()


func set_main_ref(main: Control) -> void:
	_main = main


func _on_LineEditName_text_changed(new_text: String) -> void:
	_btn_create.disabled = new_text.empty()


func _on_ButtonCreate_pressed() -> void:
	var collection_name: String = _txt_collection_name.text
	var collection_type: int = _opt_collection_type.selected
	if collection_name.empty():
		return
	_main.create_collection(collection_name, collection_type)
	queue_free()

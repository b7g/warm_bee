extends Control

var _main: Control

onready var _txt_entry_name: LineEdit = $VC/LineEditName
onready var _opt_entry_type: OptionButton = $VC/HC/OptionButtonType
onready var _btn_create: Button = $VC/ButtonCreate


func _ready() -> void:
	for type_id in Structure.get_entry_types().size():
		_opt_entry_type.add_item(Structure.get_entry_type_display_names()[type_id])
	_txt_entry_name.grab_focus()


func set_main_ref(main: Control) -> void:
	_main = main


func _on_LineEditName_text_changed(new_text: String) -> void:
	_btn_create.disabled = new_text.empty()


func _on_ButtonCreate_pressed() -> void:
	var entry_name: String = _txt_entry_name.text
	var entry_type: int = _opt_entry_type.selected
	if entry_name.empty():
		return
	Data.create_entry(entry_name, entry_type)
	queue_free()

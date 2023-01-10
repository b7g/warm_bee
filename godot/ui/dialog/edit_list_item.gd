extends ColorRect

var _item_key: String
var _text: String
var _item_ui_element: Control

onready var _txt_item_text: TextEdit = $CC/VC/TextEdit
onready var _btn_edit: Button = $CC/VC/HC/ButtonEdit


func _ready() -> void:
	_txt_item_text.text = _text
	_txt_item_text.grab_focus()


func set_item_key(item_key: String) -> void:
	_item_key = item_key


func set_text(text: String) -> void:
	_text = text


func set_ui_item_ref(ui_item: Control) -> void:
	_item_ui_element = ui_item


func _on_TextEdit_text_changed() -> void:
	_btn_edit.disabled = _txt_item_text.text.empty()


func _on_ButtonEdit_pressed() -> void:
	var new_text: String = _txt_item_text.text
	Data.edit_list_entry_item(_item_key, new_text)
	_item_ui_element.update_text(new_text)
	queue_free()


func _on_ButtonCancel_pressed() -> void:
	queue_free()

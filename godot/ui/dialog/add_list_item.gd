extends ColorRect

onready var _txt_item_text: TextEdit = $CC/VC/TextEdit
onready var _btn_create: Button = $CC/VC/HC/ButtonCreate


func _ready() -> void:
	_txt_item_text.grab_focus()


func _on_TextEdit_text_changed() -> void:
	_btn_create.disabled = _txt_item_text.text.empty()


func _on_ButtonCreate_pressed() -> void:
	Data.add_list_entry_item(_txt_item_text.text)
	queue_free()


func _on_ButtonCancel_pressed():
	queue_free()

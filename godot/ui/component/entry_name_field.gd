extends LineEdit

var _interface: Control

var _entry_id_or_null = null
var _entry_name: String


func set_interface_ref(interface: Control) -> void:
	_interface = interface


func set_entry_data(entry_id_or_null, entry_name: String) -> void:
	_entry_id_or_null = entry_id_or_null
	_entry_name = entry_name
	visible = not _entry_id_or_null == null
	text = _entry_name


func _on_EntryNameField_text_entered(_new_text: String) -> void:
	release_focus()


func _on_EntryNameField_focus_exited() -> void:
	_change_entry_name(text)


func _change_entry_name(new_name: String) -> void:
	if _entry_id_or_null == null:
		return
	if new_name.empty():
		text = _entry_name
		return
	if new_name == _entry_name:
		return
	_entry_name = new_name
	Data.change_entry_name(new_name)
	_interface.change_entry_name(_entry_id_or_null, new_name)

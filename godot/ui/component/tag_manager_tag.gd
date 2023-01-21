extends PanelContainer

var _tag_key: String
var _tag_name: String

onready var _check_box_select: CheckBox = $HC/CheckBoxSelect
onready var _line_edit_name: LineEdit = $HC/LineEditName


func _ready() -> void:
	_line_edit_name.text = _tag_name


func set_tag_info(tag_key: String, tag_name: String) -> void:
	_tag_key = tag_key
	_tag_name = tag_name


func set_selected() -> void:
	_check_box_select.pressed = true


func get_name() -> String:
	return _tag_name


func is_selected() -> bool:
	return _check_box_select.pressed


func get_tag_key() -> String:
	return _tag_key


func _on_LineEditName_text_entered(_new_text: String) -> void:
	release_focus()


func _on_LineEditName_focus_exited() -> void:
	_change_tag_name(_line_edit_name.get_text())


func _change_tag_name(new_name: String) -> void:
	if new_name.empty():
		_line_edit_name.set_text(_tag_name)
		return
	if new_name == _tag_name:
		return
	var change_success: bool = Data.change_tag_name(_tag_key, new_name)
	if change_success:
		_tag_name = new_name
	else:
		_line_edit_name.set_text(_tag_name)

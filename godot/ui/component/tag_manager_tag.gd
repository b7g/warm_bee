extends PanelContainer

var _tag_key: String
var _tag_name: String

onready var _check_box_select: CheckBox = $HC/CheckBoxSelect
onready var _label_name: Label = $HC/LabelName


func _ready() -> void:
	_label_name.text = _tag_name


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

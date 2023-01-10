extends PanelContainer

var _interface: Control

var _item_key: String
var _item: Dictionary

onready var _label_text: Label = $MC/HC/LabelText


func _ready() -> void:
	_label_text.text = _item["text"]


func set_interface_ref(interface: Control) -> void:
	_interface = interface


func set_item_key(item_key: String) -> void:
	_item_key = item_key


func set_item(item: Dictionary) -> void:
	_item = item


func update_text(new_text: String) -> void:
	_item["text"] = new_text
	_label_text.text = new_text


func _on_ButtonEdit_pressed() -> void:
	_interface.open_edit_item_dialog(_item_key, _item["text"], self)


func _on_ButtonDelete_pressed() -> void:
	_interface.open_delete_item_dialog(_item_key, self)

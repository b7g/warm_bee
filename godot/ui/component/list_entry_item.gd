extends PanelContainer

var _interface: Control

var _item_key: String
var _item: Dictionary

onready var _label_text: Label = $MC/HC/LabelText
onready var _tag_wrap: HBoxContainer = $MC/HC/TagsHC


func _ready() -> void:
	_label_text.text = _item["text"]
	display_tags()


func set_interface_ref(interface: Control) -> void:
	_interface = interface


func set_item_key(item_key: String) -> void:
	_item_key = item_key


func set_item(item: Dictionary) -> void:
	_item = item


func update_content(new_text: String, tag_keys: Array) -> void:
	_item["text"] = new_text
	_item["tags"] = tag_keys
	_label_text.text = new_text
	display_tags()


func display_tags() -> void:
	for ui_tag in _tag_wrap.get_children():
		ui_tag.queue_free()
	for tag_key in _item["tags"]:
		var tag: String = Data.get_tag_by_key(tag_key)
		var ui_tag: Control = UiShop.create_tag(tag)
		_tag_wrap.add_child(ui_tag)


func _on_ButtonEdit_pressed() -> void:
	_interface.open_edit_item_dialog(_item_key, _item["text"], self)


func _on_ButtonDelete_pressed() -> void:
	_interface.open_delete_item_dialog(_item_key, self)

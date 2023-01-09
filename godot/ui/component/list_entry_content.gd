extends VBoxContainer

var _interface: Control
var _entry: Dictionary

onready var _dialog_add_list_item_res: Resource = preload("res://ui/dialog/add_list_item.tscn")


func _ready() -> void:
	for item_text in _entry["content"]:
		add_item(item_text)


func set_interface_ref(interface: Control) -> void:
	_interface = interface


func set_entry(entry: Dictionary) -> void:
	_entry = entry


func add_item(item_text: String) -> void:
	var item: Label = Label.new()
	item.text = item_text
	add_child(item)


func _on_ButtonNewListItem_pressed() -> void:
	_interface.add_child(_dialog_add_list_item_res.instance())

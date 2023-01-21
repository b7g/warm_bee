extends VBoxContainer

var _interface: Control
var _entry: Dictionary

var _dialog_ce_list_item_res: Resource = preload("res://ui/dialog/create_or_edit_list_item.tscn")
var _list_item_res: Resource = preload("res://ui/component/list_entry_item.tscn")

onready var _ui_item_wrap: VBoxContainer = $SC/VC


func _ready() -> void:
	for item_key in _entry["items"].keys():
		var item: Dictionary = _entry["items"][item_key]
		add_item(item_key, item)


func set_interface_ref(interface: Control) -> void:
	_interface = interface


func set_entry(entry: Dictionary) -> void:
	_entry = entry


func add_item(item_key: String, item: Dictionary) -> void:
	var ui_item: Control = _list_item_res.instance()
	ui_item.set_interface_ref(_interface)
	ui_item.set_item_key(item_key)
	ui_item.set_item(item)
	_ui_item_wrap.add_child(ui_item)


func refresh_tags() -> void:
	for ui_item in _ui_item_wrap.get_children():
		ui_item.display_tags()


func _on_ButtonNewListItem_pressed() -> void:
	var dialog_add_item: Control = _dialog_ce_list_item_res.instance()
	dialog_add_item.set_mode(dialog_add_item.DIALOG_MODES.CREATE)
	_interface.add_child(dialog_add_item)

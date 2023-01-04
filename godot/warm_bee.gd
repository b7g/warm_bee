extends Control


var _collections: Array = []
var _selected_collection_index: int

var _dialog_add_entry_res: Resource = preload("res://dialog/add_entry.tscn")
var _ui_collection_button_res: Resource = preload("res://ui_component/collection_button.tscn")
var _ui_entry_button_res: Resource = preload("res://ui_component/entry_button.tscn")

onready var _collection_list: VBoxContainer = $MC/HC/VC/SCCollections/VC
onready var _entry_list: VBoxContainer = $MC/HC/VC/SCEntries/VC


func create_entry(e_name: String, type: int) -> void:
	var new_entry: Dictionary
	if type == Structure.ENTRY_TYPES.NOTE:
		new_entry = { "name": e_name, "type": type, "text": "" }
	elif type == Structure.ENTRY_TYPES.LIST:
		new_entry = { "name": e_name, "type": type, "content": [] }
	var selected_collection: Dictionary = _collections[_selected_collection_index]
	selected_collection["entries"].push_back(new_entry)
	_display_entries(selected_collection)


func display_entry_content(entry_id: int) -> void:
	pass


func _display_collections() -> void:
	for child in _collection_list.get_children():
		child.queue_free()
	for collection in _collections:
		var collection_button: Control = _ui_collection_button_res.instance()
		collection_button.set_collection(collection)
		_collection_list.add_child(collection_button)


func _display_entries(collection: Dictionary) -> void:
	for child in _entry_list.get_children():
		child.queue_free()
	for entry in collection["entries"]:
		var entry_button: Control = _ui_entry_button_res.instance()
		entry_button.set_main_ref(self)
		entry_button.set_entry(entry)
		_entry_list.add_child(entry_button)


func _on_ButtonAddCollection_pressed() -> void:
	pass


func _on_ButtonAddEntry_pressed() -> void:
	var dialog_add_entry: Control = _dialog_add_entry_res.instance()
	dialog_add_entry.set_main_ref(self)
	add_child(dialog_add_entry)

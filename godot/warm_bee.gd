extends Control


var _collections: Array = []
var _selected_collection: Dictionary

var _dialog_add_collection_res: Resource = preload("res://dialog/add_collection.tscn")
var _dialog_add_entry_res: Resource = preload("res://dialog/add_entry.tscn")
var _ui_collection_button_res: Resource = preload("res://ui_component/collection_button.tscn")
var _ui_entry_button_res: Resource = preload("res://ui_component/entry_button.tscn")

onready var _collection_list: VBoxContainer = $MC/HC/VC/SCCollections/VC
onready var _entry_list: VBoxContainer = $MC/HC/VC/SCEntries/VC
onready var _btn_add_entry: Button = $MC/HC/VC/ButtonAddEntry


func create_collection(c_name: String) -> void:
	var new_collection: Dictionary = {
		"id": _get_unique_id(),
		"name": c_name,
		"entries": []
	}
	_collections.push_back(new_collection)
	_display_collections()
	select_collection_by_id(_collections.back()["id"])


func create_entry(e_name: String, type: int) -> void:
	var new_entry: Dictionary
	if type == Structure.ENTRY_TYPES.NOTE:
		new_entry = { "id": _get_unique_id(), "name": e_name, "type": type, "text": "" }
	elif type == Structure.ENTRY_TYPES.LIST:
		new_entry = { "id": _get_unique_id(), "name": e_name, "type": type, "content": [] }
	_selected_collection["entries"].push_back(new_entry)
	_display_entries(_selected_collection)


func select_collection_by_id(collection_id: int) -> void:
	for collection in _collections:
		if collection["id"] == collection_id:
			_display_entries(collection)
			_selected_collection = collection
			break


func display_entry_content(entry_id: int) -> void:
	pass


func _get_unique_id() -> int:
	return int(Time.get_unix_time_from_system() * 1000)


func _display_collections() -> void:
	for child in _collection_list.get_children():
		child.queue_free()
	_btn_add_entry.disabled = _collections.empty()
	for collection in _collections:
		var collection_button: Control = _ui_collection_button_res.instance()
		collection_button.set_main_ref(self)
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
	var dialog_add_collection: Control = _dialog_add_collection_res.instance()
	dialog_add_collection.set_main_ref(self)
	add_child(dialog_add_collection)


func _on_ButtonAddEntry_pressed() -> void:
	var dialog_add_entry: Control = _dialog_add_entry_res.instance()
	dialog_add_entry.set_main_ref(self)
	add_child(dialog_add_entry)

extends Node

var _collections: Array = []
var _selected_collection: Dictionary
var _selected_entry: Dictionary

var _interface: Control


func _ready() -> void:
	_collections = FileIO.load_data()


func set_interface_ref(interface: Control) -> void:
	_interface = interface
	if not _collections.empty():
		_select_collection(_collections.front())


func create_collection(c_name: String) -> void:
	var new_collection: Dictionary = {
		"id": _get_unique_id(),
		"name": c_name,
		"entries": []
	}
	_collections.push_back(new_collection)
	_interface.display_collections()
	_select_collection(new_collection)
	FileIO.save_data_delayed()


func create_entry(e_name: String, type: int) -> void:
	var new_entry: Dictionary
	if type == Structure.ENTRY_TYPES.NOTE:
		new_entry = { "id": _get_unique_id(), "name": e_name, "type": type, "text": "" }
	elif type == Structure.ENTRY_TYPES.LIST:
		new_entry = { "id": _get_unique_id(), "name": e_name, "type": type, "content": [] }
	_selected_collection["entries"].push_back(new_entry)
	_selected_entry = new_entry
	_interface.entry_added(new_entry)
	FileIO.save_data_delayed()


func select_collection_by_id(collection_id: int) -> void:
	for collection in Data.get_collections():
		if collection["id"] == collection_id:
			_select_collection(collection)
			break


func select_entry_by_id(entry_id: int) -> void:
	for entry in _selected_collection["entries"]:
		if entry["id"] == entry_id:
			_selected_entry = entry
			_interface.display_entry_content(entry)
			break


func get_collections() -> Array:
	return _collections.duplicate()


func get_entries_of_selected_collection() -> Array:
	return _selected_collection["entries"].duplicate()


func get_entry_name() -> String:
	return _selected_entry["name"]


func change_entry_text(new_text: String) -> void:
	if _selected_entry.empty():
		return
	if _selected_entry["type"] == Structure.ENTRY_TYPES.NOTE:
		_selected_entry["text"] = new_text
		FileIO.save_data_delayed()


func delete_entry() -> void:
	var delete_entry_id: int = _selected_entry["id"]
	for entry_index in _selected_collection["entries"].size():
		var entry: Dictionary = _selected_collection["entries"][entry_index]
		if entry["id"] == delete_entry_id:
			_selected_collection["entries"].remove(entry_index)
			_selected_entry = {}
			_interface.entry_deleted()
			FileIO.save_data_delayed()
			break


func get_collection_data() -> Array:
	return _collections.duplicate()


func _select_collection(collection: Dictionary) -> void:
	_selected_collection = collection
	_interface.collection_selected(_selected_collection)


func _get_unique_id() -> int:
	return int(Time.get_unix_time_from_system() * 1000)

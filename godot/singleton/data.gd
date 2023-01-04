extends Node

var _collections: Array = []
var _selected_collection: Dictionary

var _main: Control


func set_main_ref(main: Control) -> void:
	_main = main


func create_collection(c_name: String) -> void:
	var new_collection: Dictionary = {
		"id": _get_unique_id(),
		"name": c_name,
		"entries": []
	}
	_collections.push_back(new_collection)
	_selected_collection = new_collection


func create_entry(e_name: String, type: int) -> int:
	var new_entry: Dictionary
	var entry_id: int = _get_unique_id()
	if type == Structure.ENTRY_TYPES.NOTE:
		new_entry = { "id": entry_id, "name": e_name, "type": type, "text": "" }
	elif type == Structure.ENTRY_TYPES.LIST:
		new_entry = { "id": entry_id, "name": e_name, "type": type, "content": [] }
	_selected_collection["entries"].push_back(new_entry)
	return entry_id


func select_collection_by_id(collection_id: int) -> void:
	for collection in Data.get_collections():
		if collection["id"] == collection_id:
			_selected_collection = collection
			_main.display_entries()
			break


func get_collections() -> Array:
	return _collections.duplicate()


func get_entries_of_selected_collection() -> Array:
	return _selected_collection["entries"].duplicate()


func _get_unique_id() -> int:
	return int(Time.get_unix_time_from_system() * 1000)
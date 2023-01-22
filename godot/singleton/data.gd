extends Node

var _collections: Array = []
var _selected_collection: Dictionary
var _selected_entry: Dictionary

var _interface: Control


func _ready() -> void:
	_collections = FileIO.load_data()


func set_interface_ref(interface: Control) -> void:
	_interface = interface
	_select_first_collection()


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
		new_entry = {
			"id": _get_unique_id(),
			"name": e_name,
			"type": type,
			"text": ""
		}
	elif type == Structure.ENTRY_TYPES.LIST:
		new_entry = {
			"id": _get_unique_id(),
			"name": e_name,
			"type": type,
			"items": {},
			"tags": {}
		}
	_selected_collection["entries"].push_back(new_entry)
	_selected_entry = new_entry
	_interface.entry_added(new_entry)
	FileIO.save_data_delayed()


func change_entry_name(new_name: String) -> void:
	_selected_entry["name"] = new_name
	FileIO.save_data_delayed()


func create_tag(tag_name: String) -> String:
	var tag_key: String = str(_get_unique_id())
	_selected_entry["tags"][tag_key] = tag_name
	FileIO.save_data_delayed()
	return tag_key


func get_tags() -> Dictionary:
	return _selected_entry["tags"]


func get_tag_by_key(tag_key: String) -> String:
	return _selected_entry["tags"][tag_key]


func get_item_tags(item_key: String) -> Array:
	return _selected_entry["items"][item_key]["tags"]


func change_tag_name(tag_key: String, new_name: String) -> bool:
	for tag_key_id in _selected_entry["tags"].keys():
		var tag_name: String = _selected_entry["tags"][tag_key_id]
		if tag_name.to_lower() == new_name.to_lower() and not tag_key_id == tag_key:
			return false 
	_selected_entry["tags"][tag_key] = new_name
	_interface.refresh_tags()
	FileIO.save_data_delayed()
	return true


func request_delete_tag_deletion(tag_key: String, ui_node: Control) -> void:
	_interface.display_delete_tag_dialog(tag_key, ui_node)


func delete_tag(tag_key: String) -> void:
	var erased: bool = _selected_entry["tags"].erase(tag_key)
	if not erased:
		push_error("Could not delete tag %s (not present)" % tag_key)
	for list_item in _selected_entry["items"].values():
		list_item["tags"].erase(tag_key)
	_interface.refresh_tags()
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
	if _selected_collection.empty():
		return []
	return _selected_collection["entries"].duplicate()


func get_collection_name() -> String:
	return _selected_collection["name"]


func get_entry_name() -> String:
	return _selected_entry["name"]


func change_note_entry_text(new_text: String) -> void:
	_selected_entry["text"] = new_text
	FileIO.save_data_delayed()


func add_list_entry_item(text: String, selected_tags: Array) -> void:
	var item_key: String = str(_get_unique_id())
	var item: Dictionary = {
		"text": text,
		"tags": selected_tags
	}
	_selected_entry["items"][item_key] = item
	_interface.add_list_entry_item(item_key, item)
	FileIO.save_data_delayed()


func delete_list_entry_item(item_key: String) -> void:
	_selected_entry["items"].erase(item_key)
	FileIO.save_data_delayed()


func edit_list_entry_item(item_key: String, new_text: String, selected_tags: Array) -> void:
	var item: Dictionary = _selected_entry["items"][item_key]
	item["text"] = new_text
	item["tags"] = selected_tags
	FileIO.save_data_delayed()


func delete_collection() -> void:
	var delete_collection_id: int = _selected_collection["id"]
	for collection_index in _collections.size():
		var collection: Dictionary = _collections[collection_index]
		if collection["id"] == delete_collection_id:
			_collections.remove(collection_index)
			_selected_collection = {}
			_select_first_collection()
			_interface.collection_deleted()
			FileIO.save_data_delayed()
			break


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


func _select_first_collection() -> void:
	if not _collections.empty():
		_select_collection(_collections.front())


func _select_collection(collection: Dictionary) -> void:
	_selected_collection = collection
	_interface.collection_selected(_selected_collection)


func _get_unique_id() -> int:
	return int(Time.get_unix_time_from_system() * 1000)

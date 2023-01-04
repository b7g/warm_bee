extends Node

const PATH_SAVE_DATA: String = "user://warm_bee.data"

var _collections: Array = []
var _selected_collection: Dictionary

var _main: Control


func _ready() -> void:
	_load_data_from_file()


func set_main_ref(main: Control) -> void:
	_main = main
	_main.display_collections()
	if not _collections.empty():
		_select_collection(_collections.front())


func create_collection(c_name: String) -> void:
	var new_collection: Dictionary = {
		"id": _get_unique_id(),
		"name": c_name,
		"entries": []
	}
	_collections.push_back(new_collection)
	_main.display_collections()
	_select_collection(new_collection)
	_save_data_to_file()


func create_entry(e_name: String, type: int) -> void:
	var new_entry: Dictionary
	var entry_id: int = _get_unique_id()
	if type == Structure.ENTRY_TYPES.NOTE:
		new_entry = { "id": entry_id, "name": e_name, "type": type, "text": "" }
	elif type == Structure.ENTRY_TYPES.LIST:
		new_entry = { "id": entry_id, "name": e_name, "type": type, "content": [] }
	_selected_collection["entries"].push_back(new_entry)
	_main.entry_added(entry_id)
	_save_data_to_file()


func select_collection_by_id(collection_id: int) -> void:
	for collection in Data.get_collections():
		if collection["id"] == collection_id:
			_select_collection(collection)
			break


func select_entry_by_id(entry_id: int) -> void:
	_main.display_entry_content(entry_id)


func get_collections() -> Array:
	return _collections.duplicate()


func get_entries_of_selected_collection() -> Array:
	return _selected_collection["entries"].duplicate()


func is_a_collection_selected() -> bool:
	return _selected_collection == null


func _select_collection(collection: Dictionary) -> void:
	_selected_collection = collection
	_main.display_entries()


func _save_data_to_file() -> void:
	var file: File = File.new()
	var err: int = file.open(PATH_SAVE_DATA, File.WRITE)
	if not err == OK:
		push_error("Could not save collection data (file creation failed) [err: %s]" % err)
		return
	file.store_string(to_json(_collections))
	file.close()


func _load_data_from_file() -> void:
	var file: File = File.new()
	if not file.file_exists(PATH_SAVE_DATA):
		return
	var err: int = file.open(PATH_SAVE_DATA, File.READ)
	if not err == OK:
		push_error("Could not load collection data (opening file failed) [err: %s]" % err)
		return
	var file_content: String = file.get_line()
	file.close()
	if file_content.empty():
		return
	var parse_result = parse_json(file_content)
	if not typeof(parse_result) == TYPE_ARRAY:
		push_error("Could not load collection data (parse result datatype mismatch)")
		return
	_collections = _clean_up_json_parse_result(parse_result)


# numerical values are parsed as float
func _clean_up_json_parse_result(parse_result: Array) -> Array:
	for collection in parse_result:
		collection["id"] = int(collection["id"])
		for entry in collection["entries"]:
			entry["id"] = int(entry["id"])
			entry["type"] = int(entry["type"])
	return parse_result


func _get_unique_id() -> int:
	return int(Time.get_unix_time_from_system() * 1000)

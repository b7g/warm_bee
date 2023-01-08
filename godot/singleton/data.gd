extends Node

const PATH_SAVE_DATA: String = "user://warm_bee.data"

var _collections: Array = []
var _selected_collection: Dictionary
var _selected_entry: Dictionary

var _timer_save_to_file: Timer
var _unsaved_changes: bool = false

var _interface: Control


func _ready() -> void:
	_load_data_from_file()
	_setup_timer_save_to_file()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		if not _unsaved_changes:
			return
		_save_data_to_file()


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
	_save_data_to_file()


func create_entry(e_name: String, type: int) -> void:
	var new_entry: Dictionary
	if type == Structure.ENTRY_TYPES.NOTE:
		new_entry = { "id": _get_unique_id(), "name": e_name, "type": type, "text": "" }
	elif type == Structure.ENTRY_TYPES.LIST:
		new_entry = { "id": _get_unique_id(), "name": e_name, "type": type, "content": [] }
	_selected_collection["entries"].push_back(new_entry)
	_selected_entry = new_entry
	_interface.entry_added(new_entry)
	_save_data_to_file()


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


func is_a_collection_selected() -> bool:
	return _selected_collection == null


func get_entry_name() -> String:
	return _selected_entry["name"]


func change_entry_text(new_text: String) -> void:
	if _selected_entry.empty():
		return
	if _selected_entry["type"] == Structure.ENTRY_TYPES.NOTE:
		_selected_entry["text"] = new_text
		_save_data_delayed_to_file()


func delete_entry() -> void:
	var delete_entry_id: int = _selected_entry["id"]
	for entry_index in _selected_collection["entries"].size():
		var entry: Dictionary = _selected_collection["entries"][entry_index]
		if entry["id"] == delete_entry_id:
			_selected_collection["entries"].remove(entry_index)
			_selected_entry = {}
			_interface.entry_deleted()
			_save_data_delayed_to_file()
			break


func _setup_timer_save_to_file() -> void:
	_timer_save_to_file = Timer.new()
	_timer_save_to_file.set_wait_time(3.0)
	_timer_save_to_file.set_one_shot(true)
	var err: int = _timer_save_to_file.connect("timeout", self, "_save_data_to_file")
	if err:
		push_error("Could not connect _timer_save_to_file to timeout signal [err: %s]" % err)
	add_child(_timer_save_to_file)


func _save_data_delayed_to_file() -> void:
	_timer_save_to_file.start()
	_unsaved_changes = true


func _select_collection(collection: Dictionary) -> void:
	_selected_collection = collection
	_interface.collection_selected(_selected_collection)


func _save_data_to_file() -> void:
	var file: File = File.new()
	var err: int = file.open(PATH_SAVE_DATA, File.WRITE)
	if not err == OK:
		push_error("Could not save collection data (file creation failed) [err: %s]" % err)
		return
	file.store_string(to_json(_collections))
	file.close()
	_unsaved_changes = false


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

extends Node

const PATH_SAVE_DATA: String = "user://warm_bee.data"

var _timer_save_to_file: Timer
var _unsaved_changes: bool = false


func _ready() -> void:
	_setup_timer_save_to_file()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		if not _unsaved_changes:
			return
		_force_save_data()


func load_data() -> Array:
	var file: File = File.new()
	if not file.file_exists(PATH_SAVE_DATA):
		return []
	var err: int = file.open(PATH_SAVE_DATA, File.READ)
	if not err == OK:
		push_error("Could not load collection data (opening file failed) [err: %s]" % err)
		return []
	var file_content: String = file.get_line()
	file.close()
	if file_content.empty():
		return []
	var parse_result = parse_json(file_content)
	if not typeof(parse_result) == TYPE_ARRAY:
		push_error("Could not load collection data (parse result datatype mismatch)")
		return []
	return _clean_up_json_parse_result(parse_result)


func save_data_delayed() -> void:
	_timer_save_to_file.start()
	_unsaved_changes = true


func _force_save_data() -> void:
	var file: File = File.new()
	var err: int = file.open(PATH_SAVE_DATA, File.WRITE)
	if not err == OK:
		push_error("Could not save collection data (file creation failed) [err: %s]" % err)
		return
	file.store_string(to_json(Data.get_collection_data()))
	file.close()
	_unsaved_changes = false


func _setup_timer_save_to_file() -> void:
	_timer_save_to_file = Timer.new()
	_timer_save_to_file.set_wait_time(3.0)
	_timer_save_to_file.set_one_shot(true)
	var err: int = _timer_save_to_file.connect("timeout", self, "_force_save_data")
	if err:
		push_error("Could not connect _timer_save_to_file to timeout signal [err: %s]" % err)
	add_child(_timer_save_to_file)


# numerical values are parsed as float
func _clean_up_json_parse_result(parse_result: Array) -> Array:
	for collection in parse_result:
		collection["id"] = int(collection["id"])
		for entry in collection["entries"]:
			entry["id"] = int(entry["id"])
			entry["type"] = int(entry["type"])
	return parse_result

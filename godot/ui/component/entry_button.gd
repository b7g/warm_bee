extends Button

var _entry: Dictionary


func _ready() -> void:
	_set_text()


func set_entry(entry: Dictionary) -> void:
	_entry = entry


func get_entry_id() -> int:
	return _entry["id"]


func change_entry_name(new_name: String) -> void:
	_entry["name"] = new_name
	_set_text()


func _set_text() -> void:
	var entry_type_text: String = Structure.get_entry_type_display_names()[_entry["type"]]
	text = "%s: %s" % [entry_type_text, _entry["name"]]


func _on_EntryButton_pressed() -> void:
	Data.select_entry_by_id(_entry["id"])

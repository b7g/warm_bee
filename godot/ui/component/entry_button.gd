extends Button

var _entry: Dictionary


func _ready() -> void:
	var entry_type_text: String = Structure.get_entry_type_display_names()[_entry["type"]]
	text = "%s: %s" % [entry_type_text, _entry["name"]]


func set_entry(entry: Dictionary) -> void:
	_entry = entry


func _on_EntryButton_pressed() -> void:
	Data.select_entry_by_id(_entry["id"])

extends Button

var _main: Control

var _entry: Dictionary


func _ready() -> void:
	var entry_type_text: String = Structure.get_entry_type_display_names()[_entry["type"]]
	text = "%s: %s" % [entry_type_text, _entry["name"]]


func set_main_ref(main: Control) -> void:
	_main = main


func set_entry(entry: Dictionary) -> void:
	_entry = entry


func _on_EntryButton_pressed() -> void:
	_main.display_entry_content(_entry["id"])

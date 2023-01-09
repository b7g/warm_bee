extends TextEdit

var _entry: Dictionary


func _ready() -> void:
	text = _entry["text"]


func set_entry(entry: Dictionary) -> void:
	_entry = entry


func _on_NoteEntryContent_text_changed() -> void:
	Data.change_note_entry_text(text)

extends PanelContainer

var _text: String

onready var _label: Label = $Label


func _ready() -> void:
	_label.text = _text


func set_text(text: String) -> void:
	_text = text

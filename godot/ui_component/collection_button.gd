extends Button

var _collection: Dictionary


func _ready() -> void:
	_setup()


func set_collection(collection: Dictionary) -> void:
	_collection = collection


func _setup() -> void:
	var type_text: String = Structure.get_collection_type_display_names()[_collection["type"]]
	text = "%s: %s" % [type_text, _collection["name"]]

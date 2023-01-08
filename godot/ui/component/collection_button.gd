extends Button

var _collection: Dictionary


func _ready() -> void:
	_setup()


func set_collection(collection: Dictionary) -> void:
	_collection = collection


func _setup() -> void:
	text = _collection["name"]


func _on_CollectionButton_pressed() -> void:
	Data.select_collection_by_id(_collection["id"])

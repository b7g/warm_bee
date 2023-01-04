extends Button

var _main: Control

var _collection: Dictionary


func _ready() -> void:
	_setup()


func set_main_ref(main: Control) -> void:
	_main = main


func set_collection(collection: Dictionary) -> void:
	_collection = collection


func _setup() -> void:
	text = _collection["name"]


func _on_CollectionButton_pressed() -> void:
	_main.select_collection_by_id(_collection["id"])

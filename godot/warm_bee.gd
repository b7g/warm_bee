extends Control


var _collections: Array = []

var _dialog_add_collection_res: Resource = preload("res://dialog/add_collection.tscn")
var _ui_collection_button_res: Resource = preload("res://ui_component/collection_button.tscn")

onready var _collection_list: VBoxContainer = $MC/VC/SC/VCCollectionList


func create_collection(c_name: String, type: int) -> void:
	var new_collection: Dictionary = {
		"name": c_name,
		"type": type,
		"content": []
	}
	_collections.push_back(new_collection)
	_display_collections()


func _display_collections() -> void:
	for child in _collection_list.get_children():
		child.queue_free()
	for collection in _collections:
		var collection_button: Control = _ui_collection_button_res.instance()
		collection_button.set_collection(collection)
		_collection_list.add_child(collection_button)


func _on_ButtonAddCollection_pressed() -> void:
	var dialog_add_collection: Control = _dialog_add_collection_res.instance()
	dialog_add_collection.set_main_ref(self)
	add_child(dialog_add_collection)

extends Control


var collections: Array = []

var _dialog_add_collection_res: Resource = preload("res://dialog/add_collection.tscn")


func create_collection(c_name: String, type: int) -> void:
	var new_collection: Dictionary = {
		"name": c_name,
		"type": type,
		"content": []
	}
	collections.push_back(new_collection)
	print(collections)


func _on_ButtonAddCollection_pressed() -> void:
	var dialog_add_collection: Control = _dialog_add_collection_res.instance()
	dialog_add_collection.set_main_ref(self)
	add_child(dialog_add_collection)

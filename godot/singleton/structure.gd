extends Node

enum COLLECTION_TYPES { NOTE, LIST }

var _collection_names: Array = ["Note", "List"]


func get_collection_types() -> Dictionary:
	return COLLECTION_TYPES.duplicate()


func get_collection_type_display_names() -> Array:
	return _collection_names.duplicate()

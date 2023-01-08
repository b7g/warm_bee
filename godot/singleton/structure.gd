extends Node

#
#	collections = []
#	collection = { id: int, name: String, entries = [entry, ...] }
#	entry (type note) = { id: int, name: String, type: int, text: String }
#	entry (type list) = { id: int, name: String, type: int, content = [list_item, ...]}
#	list_item = { text: String, is_urgent: bool, is_important: bool }
#

enum ENTRY_TYPES { NOTE } #, LIST }

const ENTRY_TYPE_NAMES: Array = ["Note"] #, "List"]


func get_entry_types() -> Dictionary:
	return ENTRY_TYPES.duplicate(true)


func get_entry_type_display_names() -> Array:
	return ENTRY_TYPE_NAMES.duplicate(true)

extends Control

var _dialog_add_collection_res: Resource = preload("res://dialog/add_collection.tscn")
var _dialog_add_entry_res: Resource = preload("res://dialog/add_entry.tscn")
var _ui_collection_button_res: Resource = preload("res://ui_component/collection_button.tscn")
var _ui_entry_button_res: Resource = preload("res://ui_component/entry_button.tscn")

onready var _collection_list: VBoxContainer = $MC/HC/VC/SCCollections/VC
onready var _entry_list: VBoxContainer = $MC/HC/VC/SCEntries/VC
onready var _btn_add_entry: Button = $MC/HC/VC/ButtonAddEntry


func _ready() -> void:
	Data.set_main_ref(self)


func collection_added() -> void:
	_display_collections()


func entry_added(entry_id: int) -> void:
	display_entries()
	display_entry_content(entry_id)


func display_entries() -> void:
	for child in _entry_list.get_children():
		child.queue_free()
	for entry in Data.get_entries_of_selected_collection():
		var entry_button: Control = _ui_entry_button_res.instance()
		entry_button.set_main_ref(self)
		entry_button.set_entry(entry)
		_entry_list.add_child(entry_button)


func display_entry_content(entry_id: int) -> void:
	pass


func _display_collections() -> void:
	for child in _collection_list.get_children():
		child.queue_free()
	var collections: Array = Data.get_collections()
	_btn_add_entry.disabled = collections.empty()
	for collection in collections:
		var collection_button: Control = _ui_collection_button_res.instance()
		collection_button.set_main_ref(self)
		collection_button.set_collection(collection)
		_collection_list.add_child(collection_button)


func _on_ButtonAddCollection_pressed() -> void:
	var dialog_add_collection: Control = _dialog_add_collection_res.instance()
	dialog_add_collection.set_main_ref(self)
	add_child(dialog_add_collection)


func _on_ButtonAddEntry_pressed() -> void:
	var dialog_add_entry: Control = _dialog_add_entry_res.instance()
	dialog_add_entry.set_main_ref(self)
	add_child(dialog_add_entry)

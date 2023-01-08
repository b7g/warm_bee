extends Control

var _dialog_add_collection_res: Resource = preload("res://ui/dialog/add_collection.tscn")
var _dialog_add_entry_res: Resource = preload("res://ui/dialog/add_entry.tscn")
var _dialog_delete_entry_res: Resource = preload("res://ui/dialog/delete_entry.tscn")
var _ui_collection_button_res: Resource = preload("res://ui/component/collection_button.tscn")
var _ui_entry_button_res: Resource = preload("res://ui/component/entry_button.tscn")

onready var _opt_collections: OptionButton = $MC/HC/VC/HC/OptCollections
onready var _entry_list: VBoxContainer = $MC/HC/VC/SCEntries/VC
onready var _btn_add_entry: Button = $MC/HC/VC/ButtonAddEntry
onready var _label_entry_name: Label = $MC/HC/VC2/MC/HC/LabelEntryName
onready var _text_edit_entry_content: TextEdit = $MC/HC/VC2/TextEditEntryContent
onready var _btn_delete_entry: Button = $MC/HC/VC2/MC/HC/ButtonDeleteEntry


func _ready() -> void:
	Data.set_interface_ref(self)
	display_collections()


func collection_selected(collection: Dictionary) -> void:
	_display_entries()
	_clear_entry_space()
	for option_index in _opt_collections.get_item_count():
		var opt_collection_id: int = _opt_collections.get_item_metadata(option_index)
		if opt_collection_id == collection["id"]:
			_opt_collections.select(option_index)
			break


func entry_added(entry: Dictionary) -> void:
	_display_entries()
	display_entry_content(entry)


func entry_deleted() -> void:
	_display_entries()
	_clear_entry_space()


func display_collections() -> void:
	_opt_collections.clear()
	for collection in Data.get_collections():
		_opt_collections.add_item(collection["name"])
		var item_index: int = _opt_collections.get_item_count() - 1
		_opt_collections.set_item_metadata(item_index, collection["id"])


func display_entry_content(entry: Dictionary) -> void:
	_label_entry_name.text = entry["name"]
	_btn_delete_entry.set_disabled(false)
	if entry["type"] == Structure.ENTRY_TYPES.NOTE:
		_text_edit_entry_content.text = entry["text"]
		_text_edit_entry_content.set_readonly(false)


func _display_entries() -> void:
	for child in _entry_list.get_children():
		child.queue_free()
	_btn_add_entry.disabled = Data.is_a_collection_selected()
	for entry in Data.get_entries_of_selected_collection():
		var entry_button: Control = _ui_entry_button_res.instance()
		entry_button.set_entry(entry)
		_entry_list.add_child(entry_button)


func _clear_entry_space() -> void:
	_label_entry_name.text = "-"
	_text_edit_entry_content.text = ""
	_text_edit_entry_content.set_readonly(true)
	_btn_delete_entry.set_disabled(true)


func _on_OptCollections_item_selected(index: int) -> void:
	var collection_id: int = _opt_collections.get_item_metadata(index)
	Data.select_collection_by_id(collection_id)


func _on_ButtonAddCollection_pressed() -> void:
	add_child(_dialog_add_collection_res.instance())


func _on_ButtonAddEntry_pressed() -> void:
	add_child(_dialog_add_entry_res.instance())


func _on_TextEditEntryContent_text_changed() -> void:
	Data.change_entry_text(_text_edit_entry_content.text)


func _on_ButtonDeleteEntry_pressed() -> void:
	var dialog_delete_entry: Control = _dialog_delete_entry_res.instance()
	dialog_delete_entry.set_entry_name(Data.get_entry_name())
	add_child(dialog_delete_entry)

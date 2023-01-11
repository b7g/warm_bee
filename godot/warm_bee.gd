extends Control

var _dialog_add_collection_res: Resource = preload("res://ui/dialog/add_collection.tscn")
var _dialog_add_entry_res: Resource = preload("res://ui/dialog/add_entry.tscn")
var _dialog_delete_entry_res: Resource = preload("res://ui/dialog/delete_entry.tscn")
var _dialog_ce_list_item_res: Resource = preload("res://ui/dialog/create_or_edit_list_item.tscn")
var _dialog_delete_item_res: Resource = preload("res://ui/dialog/delete_item.tscn")

var _ui_collection_button_res: Resource = preload("res://ui/component/collection_button.tscn")
var _ui_entry_button_res: Resource = preload("res://ui/component/entry_button.tscn")
var _ui_note_entry_content_res: Resource = preload("res://ui/component/note_entry_content.tscn")
var _ui_list_entry_content_res: Resource = preload("res://ui/component/list_entry_content.tscn")

var _entry_content: Control

onready var _opt_collections: OptionButton = $MC/HC/VC/HC/OptCollections
onready var _entry_list: VBoxContainer = $MC/HC/VC/SCEntries/VC
onready var _btn_add_entry: Button = $MC/HC/VC/ButtonAddEntry
onready var _label_entry_name: Label = $MC/HC/VC2/MC/HC/LabelEntryName
onready var _btn_delete_entry: Button = $MC/HC/VC2/MC/HC/ButtonDeleteEntry
onready var _ui_entry_content_wrap: VBoxContainer = $MC/HC/VC2


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
	var collections: Array = Data.get_collections()
	var no_collection: bool = collections.empty()
	_btn_add_entry.disabled = no_collection
	_opt_collections.disabled = no_collection
	for collection in collections:
		_opt_collections.add_item(collection["name"])
		var item_index: int = _opt_collections.get_item_count() - 1
		_opt_collections.set_item_metadata(item_index, collection["id"])


func display_entry_content(entry: Dictionary) -> void:
	_clear_entry_content()
	_label_entry_name.text = entry["name"]
	_btn_delete_entry.set_disabled(false)
	if entry["type"] == Structure.ENTRY_TYPES.NOTE:
		_entry_content = _ui_note_entry_content_res.instance()
	elif entry["type"] == Structure.ENTRY_TYPES.LIST:
		_entry_content = _ui_list_entry_content_res.instance()
		_entry_content.set_interface_ref(self)
	_entry_content.set_entry(entry)
	_ui_entry_content_wrap.add_child(_entry_content)


func add_list_entry_item(item_key: String, item: Dictionary) -> void:
	_entry_content.add_item(item_key, item)


func open_edit_item_dialog(item_key: String, text: String, ui_item: Control) -> void:
	var dialog_edit_item: Control = _dialog_ce_list_item_res.instance()
	dialog_edit_item.set_mode(dialog_edit_item.DIALOG_MODES.EDIT)
	dialog_edit_item.set_item_key(item_key)
	dialog_edit_item.set_text(text)
	dialog_edit_item.set_ui_item_ref(ui_item)
	dialog_edit_item.set_selected_tags(Data.get_item_tags(item_key))
	add_child(dialog_edit_item)


func open_delete_item_dialog(item_key: String, ui_item: Control) -> void:
	var delete_item_dialog: Control = _dialog_delete_item_res.instance()
	delete_item_dialog.set_item_key(item_key)
	delete_item_dialog.set_ui_item_ref(ui_item)
	add_child(delete_item_dialog)


func _display_entries() -> void:
	for child in _entry_list.get_children():
		child.queue_free()
	for entry in Data.get_entries_of_selected_collection():
		var entry_button: Control = _ui_entry_button_res.instance()
		entry_button.set_entry(entry)
		_entry_list.add_child(entry_button)


func _clear_entry_space() -> void:
	_clear_entry_content()
	_label_entry_name.text = "-"
	_btn_delete_entry.set_disabled(true)


func _clear_entry_content() -> void:
	if is_instance_valid(_entry_content):
		_entry_content.queue_free()


func _on_OptCollections_item_selected(index: int) -> void:
	var collection_id: int = _opt_collections.get_item_metadata(index)
	Data.select_collection_by_id(collection_id)


func _on_ButtonAddCollection_pressed() -> void:
	add_child(_dialog_add_collection_res.instance())


func _on_ButtonAddEntry_pressed() -> void:
	add_child(_dialog_add_entry_res.instance())


func _on_ButtonDeleteEntry_pressed() -> void:
	var dialog_delete_entry: Control = _dialog_delete_entry_res.instance()
	dialog_delete_entry.set_entry_name(Data.get_entry_name())
	add_child(dialog_delete_entry)

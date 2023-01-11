extends ColorRect

enum DIALOG_MODES { CREATE, EDIT }

var _dialog_mode: int
var _selected_tags: Array = []

# Set when editing
var _item_key: String
var _text: String
var _item_ui_element: Control

var _tag_manager_res: Resource = preload("res://ui/component/tag_manager.tscn")

onready var _center_wrap: CenterContainer = $CC
onready var _main_panel: PanelContainer = $CC/MainPanelPC
onready var _label_desc: Label = $CC/MainPanelPC/VC/LabelDesc
onready var _txt_item_text: TextEdit = $CC/MainPanelPC/VC/ItemTextVC/TextEdit
onready var _tag_wrap: HBoxContainer = $CC/MainPanelPC/VC/TagsVC/HC/TagHC
onready var _btn_apply: Button = $CC/MainPanelPC/VC/ButtonHC/ButtonApply


func _ready() -> void:
	if _dialog_mode == DIALOG_MODES.CREATE:
		_label_desc.text = "Create a new list item"
		_btn_apply.text = "Create"
	elif _dialog_mode == DIALOG_MODES.EDIT:
		_label_desc.text = "Edit this list item"
		_btn_apply.text = "Edit"
	display_selected_tags()
	if not _text.empty():
		_txt_item_text.text = _text
		_btn_apply.disabled = false
	_txt_item_text.grab_focus()


func set_mode(dialog_mode: int) -> void:
	_dialog_mode = dialog_mode


func set_item_key(item_key: String) -> void:
	_item_key = item_key


func set_text(text: String) -> void:
	_text = text


func set_ui_item_ref(ui_item: Control) -> void:
	_item_ui_element = ui_item


func set_selected_tags(tag_keys: Array) -> void:
	_selected_tags = tag_keys


func display_selected_tags() -> void:
	_tag_wrap.visible = not _selected_tags.empty()
	for child in _tag_wrap.get_children():
		child.queue_free()
	for tag_key in _selected_tags:
		var tag: String = Data.get_tag_by_key(tag_key)
		var ui_tag: Control = UiShop.create_tag(tag)
		_tag_wrap.add_child(ui_tag)


func tag_manager_closed() -> void:
	_main_panel.visible = true


func _on_TextEdit_text_changed() -> void:
	_btn_apply.disabled = _txt_item_text.text.empty()


func _on_ButtonAddTags_pressed() -> void:
	_main_panel.visible = false
	var tag_manager: Control = _tag_manager_res.instance()
	tag_manager.set_ce_dialog_ref(self)
	tag_manager.set_initially_selected_tags(_selected_tags)
	_center_wrap.add_child(tag_manager)


func _on_ButtonCreate_pressed() -> void:
	if _dialog_mode == DIALOG_MODES.CREATE:
		Data.add_list_entry_item(_txt_item_text.text, _selected_tags)
	elif _dialog_mode == DIALOG_MODES.EDIT:
		var new_text: String = _txt_item_text.text
		Data.edit_list_entry_item(_item_key, new_text, _selected_tags)
		_item_ui_element.update_content(new_text, _selected_tags)
	queue_free()


func _on_ButtonCancel_pressed() -> void:
	queue_free()

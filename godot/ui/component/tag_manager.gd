extends PanelContainer

var _ce_dialog_ref: Control
var _initially_selected_tags: Array

var _ui_tag_res: Resource = preload("res://ui/component/tag_manager_tag.tscn")

onready var _filter_or_create_box: LineEdit = $VC/HC/LineEditFilter
onready var _btn_create_tag: Button = $VC/HC/ButtonCreateTag
onready var _tag_container: VBoxContainer = $VC/SC/VC/TagsVC

onready var _label_no_tags: Label = $VC/SC/VC/InfoVC/LabelNoTags
onready var _label_no_result: Label = $VC/SC/VC/InfoVC/LabelNoResult


func _ready() -> void:
	_display_tags(Data.get_tags())
	_filter("")


func set_ce_dialog_ref(ref: Control) -> void:
	_ce_dialog_ref = ref


func set_initially_selected_tags(selected_tags: Array) -> void:
	_initially_selected_tags = selected_tags


func _on_LineEditFilter_text_changed(filter_text: String) -> void:
	_filter(filter_text.to_lower())


func _on_ButtonCreateTag_pressed() -> void:
	var new_tag_name: String = _filter_or_create_box.text
	var new_tag_key: String = Data.create_tag(new_tag_name)
	_add_ui_tag(new_tag_key, new_tag_name)
	_label_no_tags.visible = false
	_filter_or_create_box.text = ""
	_filter("")


func _display_tags(tags: Dictionary) -> void:
	if not tags.empty():
		_label_no_tags.visible = false
	for tag_key in tags.keys():
		var tag_name: String = tags[tag_key]
		var is_selected: bool = _initially_selected_tags.has(tag_key)
		_add_ui_tag(tag_key, tag_name, is_selected)


func _add_ui_tag(tag_key: String, tag_name: String, is_selected: bool = false) -> void:
	var ui_tag: Control = _ui_tag_res.instance()
	ui_tag.set_tag_info(tag_key, tag_name)
	_tag_container.add_child(ui_tag)
	if is_selected:
		ui_tag.set_selected()


func _filter(filter_text: String) -> void:
	var filter_inactive: bool = filter_text.empty()
	var tag_exists: bool = false
	if filter_text.empty():
		_label_no_result.visible = false
		for ui_tag in _tag_container.get_children():
			ui_tag.visible = true
	else:
		var no_result: bool = true
		for ui_tag in _tag_container.get_children():
			var tag_name: String = ui_tag.get_name().to_lower()
			if tag_name == filter_text:
				tag_exists = true
			if tag_name.find(filter_text) == -1:
				ui_tag.visible = false
			else:
				ui_tag.visible = true
				no_result = false
		if _tag_container.get_child_count() > 0:
			_label_no_result.visible = no_result
	_btn_create_tag.disabled = filter_inactive or tag_exists


func _on_ButtonAdd_pressed() -> void:
	var tag_keys: Array = []
	for ui_tag in _tag_container.get_children():
		if ui_tag.is_selected():
			tag_keys.push_back(ui_tag.get_tag_key())
	_ce_dialog_ref.set_selected_tags(tag_keys)
	_ce_dialog_ref.display_selected_tags()
	_close()


func _on_ButtonCancel_pressed() -> void:
	_close()


func _close() -> void:
	visible = false
	_ce_dialog_ref.tag_manager_closed()
	queue_free()

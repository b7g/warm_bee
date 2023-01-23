extends ColorRect

var _collection_name: String

onready var _label_desc: Label = $CC/PC/VC/LabelDesc
onready var _txt_name: LineEdit = $CC/PC/VC/VC/LineEditName
onready var _btn_rename: Button = $CC/PC/VC/HC/ButtonRename


func _ready() -> void:
	_label_desc.text = _label_desc.text % _collection_name
	_txt_name.placeholder_text = _collection_name
	_txt_name.text = _collection_name


func set_collection_name(collection_name: String) -> void:
	_collection_name = collection_name


func _rename(new_name: String) -> void:
	if new_name.empty():
		return
	if new_name == _collection_name:
		return
	Data.rename_collection(new_name)


func _on_ButtonRename_pressed() -> void:
	_rename(_txt_name.text)
	queue_free()


func _on_ButtonCancel_pressed() -> void:
	queue_free()


func _on_LineEditName_text_changed(new_text: String) -> void:
	_btn_rename.disabled = new_text.empty()


func _on_LineEditName_text_entered(new_text: String):
	_rename(new_text)

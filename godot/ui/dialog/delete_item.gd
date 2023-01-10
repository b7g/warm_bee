extends ColorRect

var _item_key: String
var _item_ui_element: Control


func set_item_key(item_key: String) -> void:
	_item_key = item_key


func set_ui_item_ref(ui_item: Control) -> void:
	_item_ui_element = ui_item


func _on_ButtonDelete_pressed() -> void:
	Data.delete_list_entry_item(_item_key)
	_item_ui_element.queue_free()
	queue_free()


func _on_ButtonCancel_pressed() -> void:
	queue_free()

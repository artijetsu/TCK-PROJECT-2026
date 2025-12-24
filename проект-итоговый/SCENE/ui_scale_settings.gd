extends OptionButton

func _ready() -> void:
	clear()
	add_item("Маленький")
	add_item("Средний")
	add_item("Большой")
	var ui := get_node("/root/UISettings")
	if ui:
		select(_index_for_key(ui.current_scale_key))
	else:
		select(1)

func _on_item_selected(index: int) -> void:
	var ui := get_node("/root/UISettings")
	if ui:
		ui.set_scale_by_index(index)

func _index_for_key(key: String) -> int:
	if key == "маленький":
		return 0
	if key == "средний":
		return 1
	if key == "большой":
		return 2
	return 1

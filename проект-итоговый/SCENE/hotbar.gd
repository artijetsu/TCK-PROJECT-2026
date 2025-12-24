extends Control

@onready var panel: Panel = $Panel
@onready var hbox: HBoxContainer = $Panel/MarginContainer/HBox
const BASE_SLOT := 96
const BASE_SEP := 8
var slots: Array[Button] = []

func _ready() -> void:
	add_to_group("Hotbar")
	visible = true
	for child in hbox.get_children():
		if child is Button:
			slots.append(child)
	_update_scale()
	_update_position()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_update_position()

func _update_scale() -> void:
	var factor: float = 1.0
	var ui := get_node_or_null("/root/UISettings")
	if ui:
		factor = ui.current_factor
	var sep: int = int(round(BASE_SEP * factor))
	var slot: int = int(round(BASE_SLOT * factor))
	hbox.add_theme_constant_override("separation", sep)
	for b in slots:
		b.custom_minimum_size = Vector2(slot, slot)
	var cols: int = slots.size()
	var w: int = cols * slot + (cols - 1) * sep
	var h: int = slot
	panel.custom_minimum_size = Vector2(w + 24, h + 24)
	self.custom_minimum_size = panel.custom_minimum_size

func _update_position() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var width: float = panel.custom_minimum_size.x
	var height: float = panel.custom_minimum_size.y
	position = Vector2((viewport_size.x - width) / 2.0, viewport_size.y - height - 24)

func add_item(texture: Texture2D) -> bool:
	for b in slots:
		if b.icon == null:
			b.icon = texture
			return true
	return false

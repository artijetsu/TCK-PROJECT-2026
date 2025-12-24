extends Node

var current_scale_key: String = "средний"
var current_factor: float = 1.0
var baseline: Dictionary = {}

func _ready() -> void:
	_load_saved()
	set_scale_by_key(current_scale_key)
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	apply_to_tree()

func set_scale_by_key(key: String) -> void:
	current_scale_key = key
	current_factor = _factor_for_key(key)
	_apply_theme_defaults()
	apply_to_tree()
	_save_current()

func set_scale_by_index(index: int) -> void:
	var key := "средний"
	if index == 0:
		key = "маленький"
	elif index == 1:
		key = "средний"
	elif index == 2:
		key = "большой"
	set_scale_by_key(key)

func get_index_for_key() -> int:
	match current_scale_key:
		"маленький":
			return 0
		"средний":
			return 1
		"большой":
			return 2
		_:
			return 1

func apply_to_tree() -> void:
	var root: Node = get_tree().get_root()
	_apply_rec(root)

func _on_node_added(node: Node) -> void:
	_apply_to_node(node)

func _apply_rec(node: Node) -> void:
	_apply_to_node(node)
	for child in node.get_children():
		_apply_rec(child)

func _apply_to_node(node: Node) -> void:
	if node is Button:
		var base := _get_baseline(node, "font_size")
		node.add_theme_font_size_override("font_size", int(round(base * current_factor)))
	elif node is Label:
		var base2 := _get_baseline(node, "font_size")
		node.add_theme_font_size_override("font_size", int(round(base2 * current_factor)))
	elif node is RichTextLabel:
		var base3 := _get_baseline(node, "normal_font_size")
		node.add_theme_font_size_override("normal_font_size", int(round(base3 * current_factor)))
	elif node is OptionButton:
		var base4 := _get_baseline(node, "font_size")
		node.add_theme_font_size_override("font_size", int(round(base4 * current_factor)))

func _get_baseline(node: Node, prop: String) -> int:
	var key := str(node.get_path(), ":", prop)
	if baseline.has(key):
		return baseline[key]
	var size := 0
	if prop == "normal_font_size" and node is RichTextLabel:
		size = (node as RichTextLabel).get_theme_font_size("normal_font_size")
	else:
		size = (node as Control).get_theme_font_size("font_size")
	baseline[key] = size
	return size

func _apply_theme_defaults() -> void:
	var t := Theme.new()
	var button_size := int(round(22 * current_factor))
	var label_size := int(round(22 * current_factor))
	var rich_size := int(round(22 * current_factor))
	t.set_font_size("font_size", "Button", button_size)
	t.set_font_size("font_size", "Label", label_size)
	t.set_font_size("normal_font_size", "RichTextLabel", rich_size)
	get_window().theme = t

func _factor_for_key(key: String) -> float:
	match key:
		"маленький":
			return 0.85
		"средний":
			return 1.0
		"большой":
			return 1.25
		_:
			return 1.0

func _save_current() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load("user://settings.cfg")
	if err != OK:
		cfg = ConfigFile.new()
	cfg.set_value("ui", "scale", current_scale_key)
	cfg.save("user://settings.cfg")

func _load_saved() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK:
		var key := str(cfg.get_value("ui", "scale", current_scale_key))
		if key != "":
			current_scale_key = key

extends Node2D
@onready var hotbar_scene = preload("res://SCENE/hotbar.tscn")

func _ready():
	print("Сцена 001 открыта")
	var hb = hotbar_scene.instantiate()
	add_child(hb)

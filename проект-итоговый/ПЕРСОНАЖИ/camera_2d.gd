extends Camera2D


func _ready() -> void:
	# Включаем сглаживание
	position_smoothing_enabled = true
	
	
	# Приближение камеры
	zoom = Vector2(4.0, 4.0)
	
	# Убираем лимиты карты (ставим очень большие значения), чтобы камера следила везде
	limit_left = 35
	limit_right = 317
	limit_top = 32
	limit_bottom = 304
	
	# Делаем эту камеру активной
	make_current()
	
	# Отключаем "мертвую зону" (Drag Margins), чтобы камера всегда держала игрока в центре
	drag_horizontal_enabled = false
	drag_vertical_enabled = false
	
	# Сбрасываем смещение
	offset = Vector2.ZERO
	
	# Гарантируем, что камера привязана к родителю
	top_level = false
	
	# Синхронизируем обновление камеры с физикой
	process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS

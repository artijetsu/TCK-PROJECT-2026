extends Button

func _on_pressed() -> void:
	print("Кнопка Выход нажата.")
	# Завершаем работу приложения
	get_tree().quit()

extends Button
func _on_quit_btn_pressed():
	print("Кнопка Выход нажата.")
	# Завершаем работу приложения
	get_tree().quit()

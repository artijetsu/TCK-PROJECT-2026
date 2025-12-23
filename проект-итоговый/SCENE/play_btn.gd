extends Button


# Функция вызывается при нажатии на кнопку "Играть"
func _on_pressed():
	# Добавляем отладочное сообщение
	print("Кнопка Играть нажата. Попытка перехода на res://SCENE/scene001.tscn")
	
	var target_scene = "res://SCENE/scene001.tscn"
	if ResourceLoader.exists(target_scene):
		# Переходим на сцену scene001.tscn
		get_tree().change_scene_to_file(target_scene)
	else:
		print("ОШИБКА: Сцена не найдена по пути: ", target_scene)

# Функция вызывается при нажатии на кнопку "Настройки"
func _on_settings_btn_pressed():
	print("Кнопка Настройки нажата.")
	# Переходим на сцену settings.tscn
	get_tree().change_scene_to_file("res://SCENE/settings.tscn")
  
# Функция вызывается при нажатии на кнопку "Выйти"
func _on_quit_btn_pressed():
	print("Кнопка Выход нажата.")
	# Завершаем работу приложения
	get_tree().quit()

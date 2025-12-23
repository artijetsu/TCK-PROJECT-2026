extends Button


# Функция вызывается при нажатии на кнопку "Играть"
func _on_pressed():
	# Переходим на сцену scene001.tscn
	get_tree().change_scene_to_file("res://SCENE/scene001.tscn")
	

# Функция вызывается при нажатии на кнопку "Настройки"
func _on_settings_btn_pressed():
	# Переходим на сцену settings.tscn
	get_tree().change_scene_to_file("res://SCENE/settings.tscn")
  

# Функция вызывается при нажатии на кнопку "Выйти"
func _on_quit_btn_pressed():
	# Завершаем работу приложения
	get_tree().quit()

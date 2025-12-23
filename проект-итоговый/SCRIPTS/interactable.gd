extends Area2D
class_name Interactable

# Сигнал, который отправляется при взаимодействии
signal interacted(body)

# Тип кнопки для взаимодействия (по умолчанию "ui_accept" - Пробел/Enter)
@export var interaction_action: String = "ui_accept"

# Метод, вызываемый игроком
func interact(body):
	print("Interacted with ", name)
	interacted.emit(body)

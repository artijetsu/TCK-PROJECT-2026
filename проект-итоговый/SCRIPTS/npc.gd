extends Interactable
# Наследуемся от Interactable, чтобы объект мог взаимодействовать с игроком

# Экспортируемая переменная имени NPC. По умолчанию "NPC". 
# Можно менять в редакторе Godot для каждого экземпляра.
@export var npc_name: String = "NPC"

# Текст диалога по умолчанию, если не задан массив строк.
# @export_multiline позволяет удобно редактировать многострочный текст в редакторе.
@export_multiline var dialogue_text: String = "Привет! Я просто NPC."

# Массив строк для диалога. Позволяет задать последовательность реплик.
# Typed Array [String] гарантирует, что внутри будут только строки.
@export var dialogue_lines: Array[String] = []

# Ссылка на узел HintLabel (надпись над головой).
# @onready гарантирует, что переменная инициализируется только когда узел готов (после _ready).
@onready var hint_label = $HintLabel

# Функция инициализации скрипта. Вызывается при появлении объекта на сцене.
func _ready():
	# Для NPC оставляем взаимодействие на Е
	interaction_action = "key_e"
	
	# Скрываем подсказку при запуске игры, чтобы она не висела постоянно
	if hint_label:
		hint_label.visible = false
		hint_label.text = "Нажмите Е чтобы поговорить"
	
	# Подключаем сигналы зоны (Area2D):
	# body_entered срабатывает, когда физическое тело входит в зону
	body_entered.connect(_on_body_entered)
	# body_exited срабатывает, когда физическое тело выходит из зоны
	body_exited.connect(_on_body_exited)

# Обработчик входа тела в зону взаимодействия
func _on_body_entered(body):
	# Проверяем, что вошедшее тело - это игрок (CharacterBody2D)
	# Также проверяем body != get_parent(), чтобы NPC не реагировал сам на себя (если бы у него была коллизия в родителе)
	if body is CharacterBody2D and body != get_parent():
		# Если условие выполнено и метка существует, показываем её
		if hint_label:
			hint_label.visible = true

# Обработчик выхода тела из зоны взаимодействия
func _on_body_exited(body):
	# Аналогичная проверка: если игрок вышел
	if body is CharacterBody2D and body != get_parent():
		# Скрываем метку
		if hint_label:
			hint_label.visible = false

# Основная функция взаимодействия. Вызывается игроком (скрипт character_body_2d.gd)
func interact(body):
	# Вызываем родительский метод (если там есть логика)
	super.interact(body)
	# Пишем в консоль для отладки
	print("Говорим с NPC...")
	
	# Ищем узел интерфейса диалогов в дереве сцены по группе "DialogueUI"
	# Это позволяет не привязывать жесткие пути к узлам
	var dialogue_ui = get_tree().get_first_node_in_group("DialogueUI")
	
	# Если UI диалога найден
	if dialogue_ui:
		# Создаем временный массив для структур данных диалога
		# Явно указываем тип Array[Dictionary] для строгости типов
		var lines: Array[Dictionary] = []
		
		# Проверяем, заполнен ли массив dialogue_lines в редакторе
		if dialogue_lines.size() > 0:
			# Если да, проходимся по каждой строке и добавляем её в список
			for line in dialogue_lines:
				lines.append({
					"name": npc_name, # Имя говорящего
					"text": line      # Текст реплики
				})
		else:
			# Иначе используем одну дефолтную строку dialogue_text
			lines.append({
				"name": npc_name,
				"text": dialogue_text
			})
			
		# Запускаем диалог через метод start_dialogue UI-компонента
		dialogue_ui.start_dialogue(lines)
	else:
		# Если UI не найден, выводим ошибку в консоль
		print("ОШИБКА: Не найден UI диалога! Убедитесь, что dialogue_box.tscn добавлен в сцену.")

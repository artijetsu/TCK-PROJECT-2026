extends CharacterBody2D

# Настройки скорости передвижения
@export var speed: float = 200.0
# Параметр для ускорения (бег) - хотя в Undertale его нет, оставим на всякий случай
@export var run_speed: float = 350.0

# Ссылка на анимационный спрайт. 
@onready var animated_sprite: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D

# Зона взаимодействия
var interaction_area: Area2D

func _ready() -> void:
	# Создаем зону взаимодействия программно
	interaction_area = Area2D.new()
	interaction_area.name = "InteractionArea"
	add_child(interaction_area)
	
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 60.0 # Радиус взаимодействия
	collision_shape.shape = shape
	interaction_area.add_child(collision_shape)

func _physics_process(delta: float) -> void:
	# Реализация управления через WASD вручную
	var input_x = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
	var input_y = int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))
	
	# Создаем вектор направления и нормализуем его, чтобы скорость по диагонали была такой же
	var direction = Vector2(input_x, input_y).normalized()
	
	var current_speed = speed
	
	if direction:
		velocity = direction * current_speed
		update_animation(direction)
	else:
		# Плавная остановка (friction)
		velocity = velocity.move_toward(Vector2.ZERO, current_speed)
		# Останавливаем анимацию на последнем кадре или сбрасываем
		if animated_sprite.is_playing():
			animated_sprite.stop()
			# Чтобы персонаж оставался в "стоячей" позе, можно переключить на frame 0
			# animated_sprite.frame = 0 

	move_and_slide()
	
	# Проверка взаимодействия (Пробел/Enter)
	if Input.is_action_just_pressed("ui_accept"):
		try_interact("ui_accept")
	
	# Проверка взаимодействия на E (английскую)
	if Input.is_key_pressed(KEY_E):
		# Используем is_key_pressed с простым debounce или проверкой, 
		# но лучше is_action_just_pressed если бы мы добавили action.
		# Так как мы не можем добавить action через код, сделаем простую проверку нажатия.
		# Для однократного срабатывания лучше использовать флаг или just_pressed логику.
		# Но в _physics_process это может сработать много раз.
		# Поэтому лучше проверять Input.is_physical_key_pressed(KEY_E) но с логикой just_pressed?
		# В Godot 4 есть Input.is_key_label_pressed.
		# Для надежности "just pressed" без action map, нужно сохранять состояние.
		pass # Реализуем ниже через _unhandled_input или оставим тут с простым хаком?
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_E:
				try_interact("key_e")

func try_interact(action_type: String):
	var areas = interaction_area.get_overlapping_areas()
	for area in areas:
		# Проверяем, есть ли у объекта свойство interaction_action
		# Если нет, считаем что он реагирует на все (или на ui_accept по умолчанию)
		var target_action = "ui_accept"
		if "interaction_action" in area:
			target_action = area.interaction_action
		
		# Если действие совпадает
		if target_action == action_type:
			if area.has_method("interact"):
				area.interact(self)
				return # Взаимодействуем только с одним объектом за раз

# Функция обновления анимации в зависимости от направления
func update_animation(dir: Vector2):
	# Логика приоритетов анимации.
	# Если мы движемся по диагонали (например, Вверх-Вправо),
	# можно выбирать анимацию на основе того, какая ось "сильнее" нажата,
	# но так как normalized() уравнивает их, возьмем простой приоритет.
	
	# Приоритет боковой анимации (как в Undertale, часто бок важнее)
	if dir.x != 0:
		animated_sprite.play("right")
		# Отражаем спрайт если идем влево
		animated_sprite.flip_h = (dir.x < 0)
	elif dir.y != 0:
		if dir.y > 0:
			animated_sprite.play("down")
		else:
			animated_sprite.play("top")

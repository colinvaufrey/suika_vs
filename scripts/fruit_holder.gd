extends Path2D
class_name FruitHolder

@export var speed: float = 0.1

@onready var _holder: PathFollow2D = $Holder

var _held_fruit: Fruit = null
var left_x: int
var right_x: int

signal fruit_released(fruit: Fruit, position: Vector2)

func _ready() -> void:
	left_x = global_position.x + curve.get_point_position(0).x
	right_x = global_position.x + curve.get_point_position(1).x


func _physics_process(delta: float) -> void:
	var horizontal_input := Input.get_axis("move_left", "move_right")
	_holder.progress_ratio = clampf(_holder.progress_ratio + horizontal_input * speed * delta, 0, 1.0)
	if Input.is_action_just_pressed("release"):
		release_held_fruit()


func set_held_fruit(fruit: Fruit) -> void:
	_holder.add_child(fruit)
	_held_fruit = fruit
	_held_fruit.set_collision_enabled(false)


func release_held_fruit() -> void:
	_held_fruit.set_collision_enabled(true)
	fruit_released.emit(_held_fruit, _holder.global_position)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.position.x >= left_x and event.position.x <= right_x:
			_holder.progress = event.position.x - left_x

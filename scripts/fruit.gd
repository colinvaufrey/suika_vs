extends RigidBody2D
class_name Fruit

@export var fruit_type: int = 0

@onready var _sprite: Sprite2D = $Sprite
@onready var _collision: CollisionPolygon2D = $Collision

var fuse_priority: int = 0
var currently_fusing: bool = false
var triggers_game_over: bool = false

var _fruit_to_fuse_into: Fruit = null
var _fusing_progress: float = 0.0
var _fruit_resource: FruitResource = null
var _default_sprite_scale: float = 1.0

signal merged(score: int)

func _ready() -> void:
	_default_sprite_scale = _sprite.scale.x
	set_fruit_type(fruit_type)


func set_fruit_type(new_type: int) -> void:
	fruit_type = new_type
	_fruit_resource = Global.fruit_resources[fruit_type]
	_sprite.texture = _fruit_resource.texture
	_collision.polygon = _fruit_resource.collision_polygon
	var target_sprite_scale := Global.FRUIT_BASE_SIZE_FACTOR * Vector2(_default_sprite_scale * _fruit_resource.size_modifer, _default_sprite_scale * _fruit_resource.size_modifer)
	var target_collision_scale := Global.FRUIT_BASE_SIZE_FACTOR * Vector2(_fruit_resource.size_modifer, _fruit_resource.size_modifer)
	_sprite.scale = target_sprite_scale
	_collision.scale = target_collision_scale


func transition_fruit_type(new_type: int) -> void:
	fruit_type = new_type
	_fruit_resource = Global.fruit_resources[fruit_type]
	_sprite.texture = _fruit_resource.texture
	_collision.polygon = _fruit_resource.collision_polygon
	var scale_tween := get_tree().create_tween()
	var target_sprite_scale := Global.FRUIT_BASE_SIZE_FACTOR * Vector2(_default_sprite_scale * _fruit_resource.size_modifer, _default_sprite_scale * _fruit_resource.size_modifer)
	var target_collision_scale := Global.FRUIT_BASE_SIZE_FACTOR * Vector2(_fruit_resource.size_modifer, _fruit_resource.size_modifer)
	scale_tween.tween_property(_sprite, "scale", target_sprite_scale, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	await scale_tween.parallel().tween_property(_collision, "scale" ,target_collision_scale, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT).finished
	currently_fusing = false


func get_colliding_fruits() -> Array[Fruit]:
	var colliding_fruits: Array[Fruit] = []
	for body in get_colliding_bodies():
		if body is Fruit:
			colliding_fruits.append(body)
	return colliding_fruits


func _process(delta: float) -> void:
	if _fruit_to_fuse_into != null:
		_fusing_progress += delta
		global_position = lerp(global_position, _fruit_to_fuse_into.global_position, _fusing_progress)
		if _fusing_progress > 1.0:
			_fruit_to_fuse_into = null
			_fusing_progress = 1.0
			queue_free()


func _physics_process(_delta: float) -> void:
	var colliding_fruits = get_colliding_fruits()
	for fruit in colliding_fruits:
		if fruit.fruit_type == fruit_type and fruit.fuse_priority > fuse_priority and !currently_fusing and !fruit.currently_fusing:
			fuse_with(fruit)
			break


func disappear_into(other_fruit: Fruit) -> void:
	currently_fusing = true
	_sprite.z_index = -1
	set_collision_enabled(false)
	_fruit_to_fuse_into = other_fruit
	get_tree().create_tween().tween_property(_sprite, "self_modulate", Color.TRANSPARENT, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)


func fuse_with(other_fruit: Fruit) -> void:
	currently_fusing = true
	transition_fruit_type(fruit_type + 1)
	fuse_priority = other_fruit.fuse_priority
	other_fruit.disappear_into(self)
	emit_signal("merged", _fruit_resource.score_value)


func set_collision_enabled(state: bool) -> void:
	_collision.disabled = !state
	set_freeze_enabled(!state)


func start_game_over_trigger_timer() -> void:
	get_tree().create_timer(Global.FRUIT_ENABLES_GAME_OVER_TIMER).timeout.connect(func():
		triggers_game_over = true
	)

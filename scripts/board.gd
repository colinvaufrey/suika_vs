extends StaticBody2D
class_name Board

@export var fruit_scene: PackedScene = preload("res://scenes/fruit.tscn")
@export var next_fruit_ui: NextFruitUI
@export var score_label: Label
@export var fruit_holder: FruitHolder
@export var fruits_container: Node

var fruits_spawned: int = 0
var score: int = 0
var next_fruit_type: int = 0

func _ready() -> void:
	set_process(false)


func start() -> void:
	randomize()
	fruit_holder.fruit_released.connect(_on_fruit_holder_released)
	_generate_new_fruit()
	_update_score_label()


func _generate_new_fruit() -> void:
	var fruit: Fruit = fruit_scene.instantiate()
	fruit.merge_priority = fruits_spawned
	fruits_spawned += 1
	fruit_holder.set_held_fruit(fruit)
	fruit.set_fruit_type(next_fruit_type)
	next_fruit_type = randi() % 4
	next_fruit_ui.set_fruit(Global.fruit_resources[next_fruit_type])


func _on_fruit_holder_released(fruit: Fruit, position: Vector2) -> void:
	fruit.get_parent().remove_child(fruit)
	fruits_container.add_child(fruit)
	fruit.connect("merged", _increase_score)
	fruit.global_position = position
	_generate_new_fruit()


func _increase_score(value: int) -> void:
	score += value
	_update_score_label()


func _update_score_label() -> void:
	score_label.text = "Score : %d" % score


func _on_game_over_area_fruit_overlaps(fruit: Fruit) -> void:
	print("Game Over !")

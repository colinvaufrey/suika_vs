extends Node

@export var fruit_scene: PackedScene = preload("res://scenes/fruit.tscn")

@onready var fruit_holder: FruitHolder = $"2DLayer/World2D/FruitHolder"
@onready var fruits_container: Node = $"2DLayer/World2D/Fruits"
@onready var music_player: MusicPlayer = $MusicPlayer

var fruits_spawned: int = 0

func _ready() -> void:
	randomize()
	fruit_holder.fruit_released.connect(_on_fruit_holder_released)
	_generate_new_fruit()
	music_player.start_random_song()


func _generate_new_fruit() -> void:
	var fruit: Fruit = fruit_scene.instantiate()
	fruit.fuse_priority = fruits_spawned
	fruits_spawned += 1
	fruit_holder.set_held_fruit(fruit)
	fruit.set_fruit_type(randi() % 4)


func _on_fruit_holder_released(fruit: Fruit, position: Vector2) -> void:
	fruit.get_parent().remove_child(fruit)
	fruits_container.add_child(fruit)
	fruit.global_position = position
	_generate_new_fruit()

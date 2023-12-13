extends Node

@export var fruit_scene: PackedScene = preload("res://scenes/fruit.tscn")

@onready var fruit_holder: FruitHolder = $"2DLayer/World2D/FruitHolder"
@onready var fruits_container: Node = $"2DLayer/World2D/Fruits"
@onready var music_player: MusicPlayer = $MusicPlayer

@onready var score_label: RichTextLabel = $UILayer/Control/ScoreLabel
@onready var next_fruit_ui: NextFruitUI = $UILayer/Control/NextFruitUI

var fruits_spawned: int = 0
var score: int = 0
var next_fruit_type: int = 0

func _ready() -> void:
	randomize()
	fruit_holder.fruit_released.connect(_on_fruit_holder_released)
	_generate_new_fruit()
	music_player.start_random_song()
	_update_score_label()


func _generate_new_fruit() -> void:
	var fruit: Fruit = fruit_scene.instantiate()
	fruit.fuse_priority = fruits_spawned
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
	score_label.text = "Score : %d" % score


func _on_game_over_area_fruit_overlaps(fruit: Fruit) -> void:
	print("Partie terminée !")

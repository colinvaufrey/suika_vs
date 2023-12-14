extends Node
class_name Game

@export var next_fruit_ui: NextFruitUI
@export var score_label: Label
@export var music_player: MusicPlayer
@export var board: Board

func _ready() -> void:
	randomize()
	music_player.start_random_song()
	board.start()

extends AudioStreamPlayer
class_name MusicPlayer

@export var _songs: Array[AudioStream]

var _number_of_tracks := 0

func start_random_song() -> void:
	if _songs.size() != 0:
		stream = _songs[randi_range(0, _songs.size() - 1)]
		play()


func _on_finished() -> void:
	await get_tree().create_timer(10).timeout
	start_random_song()

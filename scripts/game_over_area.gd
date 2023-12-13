extends Area2D
class_name GameOverArea

signal fruit_overlaps(fruit: Fruit)

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is Fruit and body.triggers_game_over:
			emit_signal("fruit_overlaps", body)

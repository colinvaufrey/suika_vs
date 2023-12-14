extends Control
class_name NextFruitUI

@onready var next_fruit_texture: TextureRect = $VBox/NextFruitTexture

func set_fruit(fruit_resource: FruitResource) -> void:
	next_fruit_texture.texture = fruit_resource.texture

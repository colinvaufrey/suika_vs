extends Node

const FRUIT_ENABLES_GAME_OVER_TIMER: float = 1.5

const FRUIT_BASE_SIZE_FACTOR := 0.07

var fruit_resources: Array[FruitResource] = [
	preload("res://resources/fruits/cherries.tres"),
	preload("res://resources/fruits/strawberry.tres"),
	preload("res://resources/fruits/grapes.tres"),
	preload("res://resources/fruits/lemon.tres"),
	preload("res://resources/fruits/orange.tres"),
	preload("res://resources/fruits/pear.tres"),
	preload("res://resources/fruits/coconut.tres"),
	preload("res://resources/fruits/pineapple.tres"),
	preload("res://resources/fruits/melon.tres"),
	preload("res://resources/fruits/watermelon.tres")
]

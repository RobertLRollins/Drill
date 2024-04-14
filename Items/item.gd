class_name Item
extends Resource

@export var display_name : String
@export var icon : Texture2D
@export var max_stack_size : int = 64
@export var world_item_scene : PackedScene

func on_use(player) -> bool:
	print("Use")
	return false

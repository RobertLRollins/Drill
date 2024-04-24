extends Area2D

@export var item_name : String

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area_that_entered: Area2D) -> void:
	var item = load("res://Items/Item Data/" + item_name + ".tres")
	Global.on_give_player_item.emit(item, 3)
	
	
	var explosion_scene = load("res://Deposits/explosion_particles.tscn")
	var new_node = explosion_scene.instantiate()
	new_node.position = self.position
	new_node.emitting = true
	self.get_parent().add_child(new_node)
	
	queue_free()

extends Area2D

@onready var coal_label = $"../CoalLabel"

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	coal_label.text = "Coal: " + str(Global.total_coal)

func _on_area_entered(area_that_entered: Area2D) -> void:
	Global.total_coal += 3
	coal_label.text = "Coal: " + str(Global.total_coal)
	
	var explosion_scene = load("res://deposits/explosion_particles.tscn")
	var new_node = explosion_scene.instantiate()
	new_node.position = self.position
	new_node.emitting = true
	self.get_parent().add_child(new_node)
	
	queue_free()

extends Control

func _process(delta: float) -> void:
	if Global.total_coal < 1:
		show_button()

func show_button():
	var button = $MarginContainer/VBoxContainer/Restart
	button.visible = true  # Make the button visible

func _on_restart_pressed():
	get_tree().reload_current_scene()
	Global.total_coal = 3
	Global.total_distance = 0

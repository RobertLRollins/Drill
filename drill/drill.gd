extends Sprite2D

var normal_speed := 150.0

var max_speed := normal_speed
var velocity := Vector2(0, 0)
var steering_factor := 10.0
var stop_threshold := 10.0 

@onready var animation = $DrillAnimation


func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	var desired_velocity := max_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * steering_factor * delta
	position += velocity * delta
	if velocity.length() < stop_threshold:
		animation.stop()
		$dirt_left.emitting = false
		$dirt_right.emitting = false
	else:
		animation.play("move")
		$dirt_left.emitting = true
		$dirt_right.emitting = true

	if direction.length() > 0.0:
		rotation = velocity.angle() + PI / 2

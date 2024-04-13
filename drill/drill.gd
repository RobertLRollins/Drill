extends Sprite2D

# The MovableSprite class extends Sprite2D to provide customizable motion behaviors.
# This class encapsulates properties like speed, steering, and animation control,
# making it easy to instantiate and manage moving sprite objects anywhere in the project.
# By using `class_name`, MovableSprite can be referenced globally without preloading,
# facilitating its use in various scenes and scripts for consistent and efficient movement dynamics.
class_name MovableSprite

# Constants and member variables
const NORMAL_SPEED: float = 150.0
const STEERING_FACTOR: float = 10.0
const STOP_THRESHOLD: float = 15.0

var velocity: Vector2 = Vector2.ZERO
var max_speed: float = NORMAL_SPEED

@onready var animation = $DrillAnimation

func _process(delta: float) -> void:
	var direction = get_input_direction()
	update_velocity_and_position(direction, delta)
	update_animation_state(direction)
	update_rotation()

# Retrieves player input and normalizes the direction vector if needed
func get_input_direction() -> Vector2:
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	if direction.length() > 1.0:
		direction = direction.normalized()
	return direction

# Updates the velocity based on the desired direction and current speed
func update_velocity_and_position(direction: Vector2, delta: float) -> void:
	var desired_velocity = max_speed * direction
	var steering_vector = desired_velocity - velocity
	velocity += steering_vector * STEERING_FACTOR * delta
	position += velocity * delta

# Manages the state of animations and particle systems based on movement
func update_animation_state(direction: Vector2) -> void:
	if velocity.length() < STOP_THRESHOLD:
		animation.stop()
		$dirt_left.emitting = false
		$dirt_right.emitting = false
	else:
		animation.play("move")
		$dirt_left.emitting = true
		$dirt_right.emitting = true

# Updates the rotation to face the movement direction
func update_rotation() -> void:
	if velocity.length() > 0.0:
		rotation = velocity.angle() + PI / 2

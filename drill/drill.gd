extends Area2D

# Constants and member variables
const NORMAL_SPEED: float = 150.0
const STEERING_FACTOR: float = 10.0
const STOP_THRESHOLD: float = 15.0

var velocity: Vector2 = Vector2.ZERO
var max_speed: float = NORMAL_SPEED
var last_multiple_600 = 0

@onready var animation = $Sprite2D/DrillAnimation
@onready var distance_label = $"../DistanceLabel"
@onready var coal_label = $"../CoalLabel"

func _ready() -> void:
	# Initialize last_multiple_600 to the nearest lower multiple of 600 of the starting total_distance
	last_multiple_600 = int(Global.total_distance / 600) * 600

func _process(delta: float) -> void:
	var direction = get_input_direction()
	update_velocity_and_position(direction, delta)
	update_animation_state(direction)
	update_rotation()
	update_distance_display()


func update_distance_display() -> void:
	distance_label.text = "Distance: " + str(Global.total_distance) + " units"


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
	var previous_position = position
	var desired_velocity = max_speed * direction
	var steering_vector = desired_velocity - velocity
	velocity += steering_vector * STEERING_FACTOR * delta
	position += velocity * delta
	Global.total_distance += (position - previous_position).length()
	
	# Check if we've passed a multiple of 600
	if int(Global.total_distance / 600) * 600 != last_multiple_600:
		last_multiple_600 = int(Global.total_distance / 600) * 600
		Global.total_coal -= 1  # Decrease coal count
		coal_label.text = "Coal: " + str(Global.total_coal)
		
# Manages the state of animations and particle systems based on movement
func update_animation_state(direction: Vector2) -> void:
	if velocity.length() < STOP_THRESHOLD:
		animation.stop()
		$Sprite2D/dirt_left.emitting = false
		$Sprite2D/dirt_right.emitting = false
	else:
		animation.play("move")
		$Sprite2D/dirt_left.emitting = true
		$Sprite2D/dirt_right.emitting = true

# Updates the rotation to face the movement direction
func update_rotation() -> void:
	if velocity.length() > 0.0:
		rotation = velocity.angle() + PI / 2

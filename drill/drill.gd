extends Area2D

# Constants
const NORMAL_SPEED: float = 150.0
const STEERING_FACTOR: float = 10.0
const STOP_THRESHOLD: float = 15.0
const DISTANCE_MULTIPLE: int = 600
const RESET_DELAY: float = 2.0  # 2 seconds delay

# Member variables
var velocity: Vector2 = Vector2.ZERO
var last_multiple_600 = 0
var original_position: Vector2
var can_move: bool = true

# Nodes
@onready var animation = $Sprite2D/DrillAnimation
@onready var distance_label = $"../CanvasLayer/Control/DistanceLabel"
@onready var coal_label = $"../CanvasLayer/Control/CoalLabel"
@onready var reset_timer = Timer.new()  # Timer for handling reset delay
@onready var flash_timer = Timer.new()  # Timer for handling flashing

func _ready() -> void:
	Global.max_speed = NORMAL_SPEED
	last_multiple_600 = get_nearest_multiple(Global.total_distance, DISTANCE_MULTIPLE)
	original_position = position
	add_child(reset_timer)
	add_child(flash_timer)
	setup_timers()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.final_score_label = $"../CanvasLayer/Control/FinalScore"

func setup_timers() -> void:
	reset_timer.wait_time = RESET_DELAY
	reset_timer.one_shot = true
	reset_timer.connect("timeout", Callable(self, "_on_reset_timer_timeout"))
	flash_timer.wait_time = 0.2  # Flash every 0.2 seconds
	flash_timer.connect("timeout", Callable(self, "_on_flash_timer_timeout"))

func _process(delta: float) -> void:
	if can_move:
		var direction = get_input_direction()
		update_velocity_and_position(direction, delta)
		update_animation(direction)
		update_rotation()
	update_labels()

func get_input_direction() -> Vector2:
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	return direction.limit_length(1.0)  # Limits the vector length to 1.0 if it exceeds that value


func update_velocity_and_position(direction: Vector2, delta: float) -> void:
	var previous_position = position
	var desired_velocity = Global.max_speed * direction
	var steering_vector = desired_velocity - velocity
	velocity += steering_vector * STEERING_FACTOR * delta
	position += velocity * delta
	update_distance(previous_position)

func update_distance(previous_position: Vector2) -> void:
	Global.total_distance += position.distance_to(previous_position)
	check_distance_milestone()

func check_distance_milestone() -> void:
	var current_multiple = get_nearest_multiple(Global.total_distance, DISTANCE_MULTIPLE)
	if current_multiple != last_multiple_600:
		last_multiple_600 = current_multiple
		decrease_coal()

func decrease_coal() -> void:
	Global.total_coal -= 1
	coal_label.text = "Coal: " + str(Global.total_coal)
	emit_item_event("coal", 1)
	check_coal_stock()

func emit_item_event(item_name: String, count: int) -> void:
	var item = load("res://Items/Item Data/" + item_name + ".tres")
	Global.on_remove_player_item.emit(item, count)

func check_coal_stock() -> void:
	if Global.total_coal < 1:
		Global.max_speed = 0
		Global.calculate_total_points($CanvasLayer/Inventory)

func update_animation(direction: Vector2) -> void:
	if velocity.length() < STOP_THRESHOLD:
		animation.stop()
		$Sprite2D/dirt_left.emitting = false
		$Sprite2D/dirt_right.emitting = false
	else:
		animation.play("move")
		$Sprite2D/dirt_left.emitting = true
		$Sprite2D/dirt_right.emitting = true

func update_rotation() -> void:
	if velocity.length() > 0.0:
		rotation = velocity.angle() + PI / 2

func update_labels() -> void:
	distance_label.text = "Distance: " + str(Global.total_distance)

func get_nearest_multiple(value: float, multiple: int) -> int:
	return int(value / multiple) * multiple


func _on_area_entered(area: Area2D):
	if area.is_in_group("reset_areas"):
		position = original_position
		decrease_coal()
		can_move = false
		reset_timer.start()
		flash_timer.start()
		visible = false  # Start with player invisible

func _on_reset_timer_timeout() -> void:
	can_move = true
	flash_timer.stop()
	visible = true  # Ensure visibility is restored when the timer ends

func _on_flash_timer_timeout() -> void:
	visible = !visible  # Toggle visibility


func _on_start_pressed():
	pass # Replace with function body.

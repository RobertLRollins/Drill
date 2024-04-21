extends Node
var total_coal: int = 3
var total_distance: int = 0
var points: int = 0
var max_speed: float = 0
var final_score_label 

signal on_give_player_item (item : Item, amount : int)

signal on_remove_player_item (item : Item, amount : int)

func calculate_total_points(inventory : Inventory) -> int:
	#points = 0  # Reset points
	for slot in inventory.slots:
		if slot.item != null:
			points += slot.item.points * slot.quantity
	print(points)
	final_score_label.text = "Final Score: " + str(points)
	return points

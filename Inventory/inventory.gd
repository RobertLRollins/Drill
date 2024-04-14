class_name Inventory
extends Node

var slots : Array[InventorySlot]
@onready var window : Panel = get_node("InventoryWindow")
@onready var info_text : Label = get_node("InventoryWindow/InfoText")
@export var starter_items : Array[Item]

func _ready ():
	pass

func _process (delta):
	pass

func toggle_window (open : bool):
	pass

func on_give_player_item (item : Item, amount : int):
	pass

func add_item (item : Item):
	pass

func remove_item (item : Item):
	pass

func get_slot_to_add (item : Item) -> InventorySlot:
	return null

func get_slot_to_remove (item : Item) -> InventorySlot:
	return null

func get_number_of_item (item : Item) -> int:
	return 0
	

extends Node

@onready var window : Panel = get_node("CraftingWindow")
@onready var ui_parent : VBoxContainer = get_node("CraftingWindow/RecipeContainer")
@onready var coal_label = get_node("/root/Level/CanvasLayer/Control/CoalLabel")

@export var crafting_recipe_ui_scene : PackedScene
@export var recipes : Array[CraftingRecipe]

var recipe_uis : Array[CraftingRecipeUI]
var inventory : Inventory

func _ready():
	inventory = get_parent().get_node("Inventory")
	
	for recipe in recipes:
		var recipe_node = crafting_recipe_ui_scene.instantiate()
		ui_parent.add_child(recipe_node)
		recipe_node.recipe = recipe
		recipe_node.crafting = self
		recipe_uis.append(recipe_node)
	
	close()

func craft(recipe: CraftingRecipe):
	for req in recipe.requirements:
		for i in range(req.quantity):
			inventory.remove_item(req.item)
			if req.item.resource_path == "res://Items/Item Data/coal.tres":
				Global.total_coal -= 1
				coal_label.text = "Coal: " + str(Global.total_coal)
				
	
	inventory.add_item(recipe.item)
	if Global.total_coal < 1:
		Global.max_speed = 0
		Global.calculate_total_points($"../Inventory")
	open()

func _process(delta):
	if Global.total_coal < 1:
		close()
	
	elif Input.is_action_just_pressed("crafting"):
		if window.visible:
			close()
		else:
			open()

func open():
	window.visible = true
	
	for recipe in recipe_uis:
		recipe.update_recipe(inventory)

func close():
	window.visible = false

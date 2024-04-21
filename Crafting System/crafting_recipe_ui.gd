class_name CraftingRecipeUI
extends Node

var item_icon : TextureRect
var recipe_text : Label
var craft_button : Button
var recipe : CraftingRecipe
var crafting

func get_nodes ():
	item_icon = get_node("ItemIcon")
	recipe_text = get_node("RecipeText")
	craft_button = get_node("CraftButton")

func update_recipe(inventory : Inventory):
	var can_craft = true
	
	for req in recipe.requirements:
		if inventory.get_number_of_item(req.item) < req.quantity:
			can_craft = false
			break
	
	get_nodes()
	craft_button.visible = can_craft
	recipe_text.text = recipe.item.display_name + "\n"
	
	var i = 0  # Counter to keep track of the items
	for req in recipe.requirements:
		if i % 2 == 0 and i > 0:  # Check if it's the start of a new line (every 2 items)
			recipe_text.text += "\n"  # Start a new line
		recipe_text.text += req.item.display_name + " x" + str(req.quantity)
		if i % 2 == 0:  # Check if it's the first column
			recipe_text.text += "    "  # Add 4 spaces of column spacing
		i += 1

# Ensure to add a newline at the end if the total number of items is odd
	if i % 2 != 0:
		recipe_text.text += "\n"

	item_icon.texture = recipe.item.icon

func _on_craft_button_pressed():
	crafting.craft(recipe)

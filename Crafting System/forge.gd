extends Area2D

func _on_area_entered(area):
	var parent_node = get_parent()
	var sibling = parent_node.get_node("Drill")
	var child
	
	if sibling:
		child = sibling.get_node("CanvasLayer/Crafting")
	
	if child:
		child.open()
	else:
		print("hahaha")

func _on_area_exited(area):
	var parent_node = get_parent()
	var sibling = parent_node.get_node("Drill")
	var child
	
	if sibling:
		child = sibling.get_node("CanvasLayer/Crafting")
	
	if child:
		child.close()
	else:
		print("hahaha")

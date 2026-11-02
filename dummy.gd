extends Control

func _on_focus_entered() -> void:
	get_node(focus_neighbor_top).grab_focus()

func do_stuff():
	pass

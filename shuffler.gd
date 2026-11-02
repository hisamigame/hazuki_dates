extends Control

signal shuffle

var flipped = false

func do_stuff():
	shuffle.emit()


func _on_focus_entered() -> void:
	modulate = Color(0.49, 0.001, 0.588, 1.0)


func _on_focus_exited() -> void:
	modulate = Color(1.0, 1.0, 1.0, 1.0)

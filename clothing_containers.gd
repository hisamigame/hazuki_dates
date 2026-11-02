extends GridContainer

var last_focus_index = 0
var children = []

signal updated(Node)

func _ready():
	children = get_children()
	for c in children:
		c.focus_entered.connect(focus_entered)


func focus_entered():
	var focused = get_viewport().gui_get_focus_owner()
	var i = children.find(focused)
	if i != -1:
		last_focus_index = i
		for c in children:
			c.modulate = Color(1.0, 1.0, 1.0, 1.0)
		focused.modulate = Color(0.49, 0.001, 0.588, 1.0)
		updated.emit(focused)

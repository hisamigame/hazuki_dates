extends Label

var index = 0
#const coolMaterial = preload("res://cool_material.tres")
const coolBG = preload('res://cool_bg.tscn')

func make_cool():
	var clone = self.duplicate()
	add_child(clone)
	#$Label.text = text
	#$Label.visible = true
	#clone.material = coolMaterial
	clone.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	clone.clip_children=CanvasItem.CLIP_CHILDREN_AND_DRAW
	clone.z_index = 1
	var tmp = coolBG.instantiate()
	clone.add_child(tmp)
	
func make_new():
	add_theme_color_override("font_color",Color(1.0, 1.0, 0.0, 1.0))
	#$Sprite2D.visible = true

extends Node2D

@export_multiline var text = ""
@export var size = 32
@export var color = Color(0.0, 1.0, 0.0, 1.0)

var time = 0.3
var t = 0.0
var do_play
var done = false

func _ready() -> void:
	$Label.text = text
	$Label.add_theme_color_override("font_color",color)
	$Label.add_theme_font_size_override("font_size",size)
	play()
	
func play():
	if not do_play:
		$Label.scale = Vector2.ONE * 6
		$Label.modulate.a = 0.0
		$Label.visible = true
		do_play = true
	
func _process(delta: float) -> void:
	if do_play and not done:
		t = t + delta
		if t <= time:
			$Label.scale = Vector2.ONE * (6 - 5*t/time)
			$Label.modulate.a = t/time
		else:
			done = true
			global.play_punch()

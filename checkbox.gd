extends Node2D

const circle = preload('res://check.png')

@export_multiline var text = ""
@export var checked = false

var time = 0.3
var t = 0.0
var do_play
var done = false

func _ready() -> void:
	$Label.text = text
	
func play():
	if not do_play:
		if checked:
			$Stamp.texture = circle

		$Stamp.scale = Vector2.ONE * 6
		$Stamp.modulate.a = 0.0
		$Stamp.visible = true
		do_play = true
	
func _process(delta: float) -> void:
	if do_play and not done:
		t = t + delta
		if t <= time:
			$Stamp.scale = Vector2.ONE * (6 - 5*t/time)
			$Stamp.modulate.a = t/time
		else:
			done = true
			global.play_punch()

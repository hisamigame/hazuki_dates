extends Node2D


var diff = 0
var speed = 1000.0

var t =0.0

var lifetime = 0.80
var fadetime = 0.4
var decel = speed/lifetime

var position0
var direction = Vector2(-1,1).normalized()

const BAD = Color(0.825, 0.0, 0.249, 1.0)
const GOOD = Color(0.115, 0.0, 0.576, 1.0)

@onready var label = $Label

func _ready() -> void:
	if diff < 0:
		label.text = str(diff)
		label.add_theme_color_override("font_color",BAD)
	else:
		label.text = "+" + str(diff)
		label.add_theme_color_override("font_color",GOOD)
	position0 = global_position
		
func _process(delta: float) -> void:
	t = t + delta
	speed = clamp(speed - decel * delta/2, 0.0, INF)
	global_position = global_position + direction * speed * delta
	speed = clamp(speed - decel * delta/2, 0.0, INF)
	scale = Vector2.ONE * (1+10*t)
	if t > fadetime:
		modulate.a = 1-(t-fadetime)/(lifetime - fadetime)
	if t > lifetime:
		queue_free()

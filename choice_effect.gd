extends Node2D


@export var text = ""
var speed = 200.0

var t =0.0

var lifetime = 0.80
var fadetime = 0.4
var decel = speed/lifetime

var direction = Vector2.UP

const BAD = Color(0.825, 0.0, 0.249, 1.0)
const GOOD = Color(0.115, 0.0, 0.576, 1.0)

@onready var label = $Label

func _ready() -> void:
	$Label.text = text
	#$Label.add_theme_color_override("font_color")
		
func _process(delta: float) -> void:
	t = t + delta
	speed = clamp(speed - decel * delta/2, 0.0, INF)
	global_position = global_position + direction * speed * delta
	speed = clamp(speed - decel * delta/2, 0.0, INF)
	scale = Vector2.ONE * (1+5*t)
	if t > fadetime:
		modulate.a = 1-(t-fadetime)/(lifetime - fadetime)
	if t > lifetime:
		queue_free()

extends Sprite2D


var x0
var A = 2.0
var freq = 4.0
var t = 0.0

func _ready() -> void:
	x0 = position.x
	if flip_v:
		A = -A

func _process(delta: float) -> void:
	t = t + delta
	position.x = x0 + A*sin(freq*t)

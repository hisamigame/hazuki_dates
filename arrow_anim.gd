extends Sprite2D


var y0
var A = 2.0
var freq = 4.0
var t = 0.0

func _ready() -> void:
	y0 = position.y
	if flip_v:
		A = -A

func _process(delta: float) -> void:
	t = t + delta
	position.y = y0 + A*sin(freq*t)

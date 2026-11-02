extends ColorRect

var t = 0.0
var time = 1.0

var active = false

func _process(delta: float) -> void:
	if active:
		t = t + delta
		modulate.a = (1.0 - t/time)
		if t > time:
			queue_free()

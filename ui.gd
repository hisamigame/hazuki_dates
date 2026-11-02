extends Control

var tokimeki = 0
var time = 0
var time_seconds=  0
var time_minutes = 0
var time_string = "10:00 pm"

const GoodEffect = preload('res://effect.tscn')
const BadEffect = preload('res://effect.tscn')

signal bad_tokimeki_change
signal good_tokimeki_change

func _ready() -> void:
	$TimeLabel.text = time_string

func update_time(v):
	time = v
	@warning_ignore("integer_division")
	time_minutes = int(time)/60
	time_seconds = time - 60*time_minutes
	if time_minutes < 2:
		time_string = "1" + str(time_minutes) + ":" + str(time_seconds).pad_zeros(2) + " pm"
	else:
		time_string = str(time_minutes-2).pad_zeros(2) + ":" + str(time_seconds).pad_zeros(2) + " am"
	$TimeLabel.text = time_string

func update_tokimeki(v):
	var diff = v-tokimeki
	if diff > 0:
		var tmp = GoodEffect.instantiate()
		tmp.diff = diff
		tmp.position = $TokimekiLabel.position +Vector2.DOWN * 16
		add_child(tmp)
		good_tokimeki_change.emit()
	elif diff < 0:
		var tmp = BadEffect.instantiate()
		tmp.diff = diff
		tmp.position = $TokimekiLabel.position +Vector2.DOWN * 16
		add_child(tmp)
		if diff < -1:
			bad_tokimeki_change.emit()
	tokimeki = v
	$TokimekiLabel.text = str(v)

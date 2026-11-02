extends Control

const bonusScene = preload('res://bonus_effect.tscn')

var tokimeki_time_series = [0]
var phone_number_get = false
var blood_type_get = false
var walk_home_get = false
var birthday_get = false
var bwh_get = false

var bonus

var tokimeki_sum = 0
var final_tokimeki
var times = []

var time = 1.5
var t = 0.0

var stamp1_time = 0.20
var stamp2_time = 0.40
var stamp3_time = 0.60
var stamp4_time = 0.80
var stamp4p_time = 1.00

var shown_bonus = false
var shown_total = false
var stamp5_time = 1.25
var stamp6_time = 1.5

var can_exit = false

var total_score = 0


func _process(delta: float) -> void:
	t = t + delta
	
	if t > stamp1_time:
		$Checkbox2.play()
		
	if t > stamp2_time:
		$Checkbox3.play()
		
	if t > stamp3_time:
		$Checkbox4.play()
		
	if t > stamp4_time:
		$Checkbox5.play()
		
	if t > stamp4p_time:
		$Checkbox6.play()
	
	if t > stamp5_time and not shown_bonus:
		shown_bonus = true
		var tmp = bonusScene.instantiate()
		tmp.text = "BONUS\n+" + str(bonus)
		tmp.position = Vector2(850,700)
		add_child(tmp)
		
	if t > stamp6_time and not shown_total:
		shown_total = true
		var tmp = bonusScene.instantiate()
		tmp.text = str(total_score) + " units ⨯ minutes"
		tmp.position = Vector2(525,800)
		tmp.color= Color(1.0, 1.0, 1.0, 1.0)
		tmp.size=64
		add_child(tmp)
	
	if t > time and not can_exit:
		can_exit = true
	if can_exit and Input.is_action_just_pressed("DoStuff"):
		get_tree().change_scene_to_file("res://hiscore_screen.tscn")

func _ready() -> void:
	var i = 0
	for tokimeki in tokimeki_time_series:
		times.append(i)
		i = i + 1
		tokimeki_sum = tokimeki_sum + tokimeki
	final_tokimeki = tokimeki_time_series[-1]
	
	$Plotter.x = times
	$Plotter.y = tokimeki_time_series
	$Plotter.plot()
	$Label5.text = str(final_tokimeki) + " tokimeki units"
	$Label6.text = str(int(round(tokimeki_sum))) + " units ⨯ minutes"
	
	$Checkbox2.checked = birthday_get
	$Checkbox3.checked = blood_type_get
	$Checkbox4.checked = walk_home_get
	$Checkbox5.checked = phone_number_get
	$Checkbox6.checked = bwh_get
	
	bonus = int(birthday_get) * 1000 + int(blood_type_get) * 1000 + int(walk_home_get) * 1000 + int(phone_number_get) * 1000 + int(bwh_get) * 1000
	total_score = tokimeki_sum + bonus
	global.score = total_score

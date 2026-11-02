extends Control

signal done(bool)

var last_focused = null
var active = false
var containers = []
var cards = []

var head = null
var torso = null
var waist = null
var feet = null

func _ready() -> void:
	containers = [$ClothingContainer1,$ClothingContainer2,$ClothingContainer3,$ClothingContainer4]
	for cont in containers:
		cont.updated.connect(update_outfit)
		for c in cont.get_children():
			cards.append(c)
			c.focus_entered.connect(update_focus)
	last_focused = cards[0]
	$Button.focus_entered.connect(update_focus)

func update_outfit(clothing : Clothes):
	match clothing.type:
		'head':
			head = clothing
		'torso':
			torso = clothing
		'waist':
			waist = clothing
		'feet':
			feet = clothing
			
	$Label.text = clothing.description
	$Image.texture = clothing.image
		

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DoStuff") and last_focused is Button:
		end()
		
func end():
	global.play_coin()
	var score = head.score + torso.score + waist.score + feet.score
	print(score)
	if score == 0 or score == -3:
		done.emit(true)
	else:
		done.emit(false)
	queue_free()
		
func activate():
	visible = true
	last_focused.grab_focus()
	active = true
	
func deactivate():
	visible = false
	active = false
	
func update_focus():
	last_focused = get_viewport().gui_get_focus_owner()
	if last_focused is Button:
		$Indicator.visible=false
	else:
		$Indicator.global_position = last_focused.global_position
		$Indicator.visible=true

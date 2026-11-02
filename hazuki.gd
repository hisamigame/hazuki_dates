extends Node2D

const neutral = preload('res://hazuki0.png')
const happy = preload('res://hazuki1.png')
const angry = preload('res://hazuki_angry.png')
const sad = preload('res://hazuki_sad.png')
const shock = preload('res://hazuki_sad.png')

func change_emote(emote):
	match emote:
		"neutral":
			$Sprite2D.texture = neutral
		"happy":
			$Sprite2D.texture = happy
		"sad":
			$Sprite2D.texture = sad
		"angry":
			$Sprite2D.texture = angry
		"shock":
			$Sprite2D.texture = shock
			knock()


func blush_on():
	$blush.visible = true
	
func blush_off():
	$blush.visible = false

func knock():
	var tween = self.create_tween()
	tween.tween_property(self,"position:x", 30,0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position:x", -30,0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"position:x", 0.0,0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#tween.play()
	global.play_incorrect()

func go_away():
	var tween = self.create_tween()
	tween.tween_property(self,'modulate:a',0.0,1.0)

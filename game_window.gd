extends Node2D

const dialogWindowScene = preload("res://dialog_window.tscn")
const choiceWindowScene = preload('res://choice_window.tscn')
const resultsWindowScene = preload("res://result_window.tscn")
const choiceEffect = preload("res://choice_effect.tscn")



var active_window = null

var hazuki_left = false
var do_end = false
var until_leaves_time = 20.0
var last_interaction_t =0.0
var t = 0.0
var t_seconds = 0
var time = 120.0
var tokimeki_drain = 1

var tokimeki = 0
var tokimeki_time_series = [0]
var soberness = 100.0

var tokimeki_decay_time = 5
var tokimeki_decay_t = 0

var phone_number_get = false
var blood_type_get = false
var walk_home_get = false
var birthday_get = false
var bwh_get = false

var levels = {}

var available_choices = ["Think of a NEW topic", "Talk about the weather", "Her favorite food", "Her work", "Her blood type", "What she will drink", "When her birthday is", "Hopes and dreams", "Her phone number", "Her three sizes"]
var choice_history = [] # list of strings

var repeated_dialog_times = 0

var ending = ''

var last_choice = 1
var last_scroll_vertical = 0.0
var choice
var tween

var active = true

var ethics_lines =[["I'm against trolleys."], ['I think people should date people,\nand dogs should date dogs.'], ["People should be nice and kind."], ["Medical professionals need ethics."]]
var stem_lines =[["Don't underestimate the speed\nat which we do mental arithemitcs\nin the fast-food business."], ["The Fourier transform is so cool."], ["Who would win?\nLaplace's Demon vs Maxwell's Demon."],["And that's why giant robots are actually\na practical weapon in space."]]
var medicine_lines = [["Necromancy and healing magic\n—completely different!"],["The field of medicine needs\nto accept Healing Magic."],["Tuition is too expensive!!"]]
var fashion_lines = [["Bald men in suits!"],["Chizuru is so stylish and cool.\nI'm definitely on team Chizuru!"],["Orange is a color, a fruit,\nand a Touhou character."],["I think your clothes are cute too.\nOr maybe cool?"]]
var culture_lines = [['So I told her:\n"Haruhi is a light novel!!"'],["Albert Camus died in a car crash.\nIsn't that interesting?"],["It's the Citizen Kane of comic books."]]
var athletics_lines = [["My handicap in golf?\nLower than you'd expect!"],["Using magic in sports is not cheating!"],["I don't want to be a burden on others,\nso I avoid team sports."]]
var video_games_lines = [["Of course I know about the minus world."], ["You beat Ikki in under 4 minutes?\nThat's so cool."], ["I used to be able to do the Daigo parry."], ["You beat the other team 5-0?\nThat's amazing."],["I wish I had more time to play video games."]]
var rock_lines = [["People who like rock music are scary!"],["Please don't make me listen to music that'll\nmake me upset."]]
var jazz_lines = [["The music here is quite nice."],["Jazz encompases a wide-range of music styles.\nIt's a very deep genre."]]
var classic_lines = [['I\'ve played Beethoven Virus on the piano.\nThat\'s 88 "panels"!'],["Chopin is from Warsaw, not from Prague."],["You think I could still play piano\nif I tried?"]]
var gardening_lines =[["I'd love to have a garden full of\nhealing herbs."],["Tomato is a fruit."],["Life would be much easier if\nchocolate bars grew on trees."],["The flower that shines in the moon's light..."], ["I wish I had a flower garden."]]
var painting_lines =[["That's so cool!\nI wish I could draw."],["The swan he painted turned into a pretty boy?!"],["Caligraphy is a form of painting."]]

var types = ['ethics', 'culture', 'medicine', 'video_games', 'fashion', 'stem', 'rock', 'classic', 'jazz', 'athletics', 'gardening', 'painting']

var always_types = ['medicine', 'video_games']
var common_types = ['culture','stem','athletics']
var rare_types = ['ethics', 'rock', 'classic', 'jazz', 'gardening', 'painting', 'fashion']

func set_tokimeki(v):
	tokimeki = v
	$UI.update_tokimeki(v)
	if tokimeki >= 60:
		$Hazuki.blush_on()
	else:
		$Hazuki.blush_off()

func _ready():
	global.play_bgm()
	set_tokimeki(0)
	for type in types:
		levels[type] = -1
	show_initial_dialog()
	$UI.bad_tokimeki_change.connect(bad_thing_happened)
	$UI.good_tokimeki_change.connect(good_thing_happened)
	$MemoryGame.win.connect(post_memory)
	$MemoryGame.types = types
	$MemoryGame.always_types = always_types
	$MemoryGame.rare_types = rare_types
	$MemoryGame.common_types = common_types
	$MemoryGame.shuffle()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Reset"):
		get_tree().change_scene_to_file("res://game_window.tscn")

func _process(delta: float) -> void:
	if active:
		t = t + delta
		if t > t_seconds + 1:
			t_seconds = t_seconds + 1
			$UI.update_time(t_seconds)
			if t < time:
				tokimeki_time_series.append(tokimeki)
		if t > time:
			do_end = true
		last_interaction_t = last_interaction_t + delta
		tokimeki_decay_t = tokimeki_decay_t + delta
		
		if tokimeki_decay_t > tokimeki_decay_time:
			set_tokimeki(tokimeki - tokimeki_drain)
			tokimeki_decay_t = 0.0
		
		if last_interaction_t > until_leaves_time:
			tokimeki_drain = 2
			if tokimeki < 40:
				hazuki_left = true
	
func good_thing_happened():
	$Correct.play()
	
func bad_thing_happened():
	tween = self.create_tween()
	tween.tween_property(self,"position:x", 30,0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position:x", -30,0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"position:x", 0.0,0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#tween.play()
	global.play_incorrect()

func show_dialog(texts, emotes=[]):
	if active_window:
		active_window.queue_free()
	var tmp = dialogWindowScene.instantiate()
	tmp.texts = texts
	tmp.emotes = emotes
	tmp.done.connect(post_dialog)
	tmp.emotion_change.connect(change_emote)
	add_child(tmp)
	active_window = tmp
	
func post_memory(type):
	if hazuki_left:
		$Hazuki.visible = false
		active = false
		show_end_dialog2()
	else:
		add_type(type)
		show_choice(true)
	
func add_type(type):
	var text
	match type:
		"ethics":
			text = "Discuss ethics"
		"culture":
			text = "Discuss humanities"
		"stem":
			text = "Discuss STEM"
		"athletics":
			text = "Discuss athletics"
		"medicine":
			text = "Discuss medicine"
		"fashion":
			text = "Discuss fashion"
		"video_games":
			text = "Discuss video games"
		"gardening":
			text = "Discuss gardening"
		"rock":
			text = "Discuss rock music"
		"jazz":
			text = "Discuss jazz music"
		"classic":
			text = "Discuss classical music"
		"painting":
			text = "Discuss painting"
	levels[type] = levels[type] + 1
	if levels[type] > 0:
		text = text + " +" + str(levels[type])
	available_choices.insert(1,text)
	
	
func post_dialog():
	if do_end:
		active = false
		show_end_dialog()
	else:
		show_choice()

func show_initial_dialog():
	var tmp = dialogWindowScene.instantiate()
	tmp.texts = ["(She's so cute. What do I say to make her like me?)"]
	tmp.color = Color(1.0, 1.0, 1.0, 1.0)
	tmp.speaker = ''
	tmp.done.connect(show_choice)
	tmp.emotion_change.connect(change_emote)
	add_child(tmp)
	active_window = tmp
	
	
func show_end_dialog():
	if active_window:
		active_window.queue_free()
	var tmp = dialogWindowScene.instantiate()
	if tokimeki >= 75:
		tmp.texts = ["I'm afraid I have to go.\nI've got work tomorrow morning.","Would you care to walk me home?"]
		tmp.emotes = ['neutral','happy']
		ending = "good"
		walk_home_get = true
	else:
		tmp.texts = ["I gotta go. It's past my bed time and I've got\nwork tomorrow morning."]
		tmp.emotes = ['sad']
		ending = "bad"
	tmp.done.connect(show_results)
	tmp.emotion_change.connect(change_emote)
	add_child(tmp)
	active_window = tmp
	
	
func show_end_dialog2():
	if active_window:
		active_window.queue_free()
	var tmp = dialogWindowScene.instantiate()
	tmp.texts = ["(Where did she go? Did she walk out on me??)"]
	tmp.color = Color(1.0, 1.0, 1.0, 1.0)
	tmp.speaker = ''
	tmp.done.connect(show_results)
	tmp.emotion_change.connect(change_emote)
	add_child(tmp)
	active_window = tmp
	

func show_results():
	# add final data
	if ending == "bad":
		$Hazuki.go_away()
	tokimeki_time_series.append(tokimeki)
	var tmp = resultsWindowScene.instantiate()
	tmp.tokimeki_time_series = tokimeki_time_series
	tmp.birthday_get = birthday_get
	tmp.blood_type_get = blood_type_get
	tmp.walk_home_get = walk_home_get
	tmp.phone_number_get = phone_number_get
	tmp.bwh_get = bwh_get
	add_child(tmp)

func change_emote(emote):
	$Hazuki.change_emote(emote)

func show_choice(new=false):
	var tmp = choiceWindowScene.instantiate()
	tmp.choices = available_choices
	tmp.last_choice = last_choice
	tmp.last_scroll_vertical = last_scroll_vertical
	tmp.new = new
	add_child(tmp)
	tmp.done.connect(execute_choice)

func cleanup_tween():
	if tween:
		tween.kill()
		position.x = 0.0

func execute_choice(choice_index, last_scroll, pos):
	last_scroll_vertical = last_scroll
	cleanup_tween()
	# update states based on choice
	# get dialog based on choice
	choice = available_choices[choice_index]
	last_choice = choice_index
	
	var tmp = choiceEffect.instantiate()
	tmp.text = choice
	tmp.global_position = pos
	add_child(tmp)
	
	if choice == "Think of a NEW topic":
		start_memory()
	else:
		last_interaction_t = 0.0
		tokimeki_decay_t = 0.0
		tokimeki_drain = 1
		hazuki_left = false
		if choice_history.has(choice):
			duplicate_choice()
		else:
			new_choice()
	choice_history.append(choice)
	
func duplicate_choice():
	show_dialog(["We already talked about this."],['sad'])
	set_tokimeki(tokimeki - 5)
	repeated_dialog_times =  repeated_dialog_times + 1
	
func start_memory():
	$MemoryGame.activate()
	
func pop_random(array, default=["I think so too."]):
	var N = len(array)
	if N > 0:
		var index = randi_range(0,N-1)
		return array.pop_at(index)
	else:
		return default
	
func new_choice():
	match choice.split(' +')[0]:
		# OUTCOME OF THESE ALL DEPEND ON CURRENT TOKIMEKI LEVEL
		"Her blood type":
			if tokimeki >= 60:
				show_dialog(["That's a weird thing to ask...","It's A."])
				set_tokimeki(tokimeki - 1)
				blood_type_get = true
			else:
				show_dialog(["Are you a vampire?"],['angry'])
				set_tokimeki(tokimeki - 5)
		"When her birthday is":
			if tokimeki >= 50:
				show_dialog(["Wow, we have the same birthday!\nThat's amazing."],['happy'])
				birthday_get = true
				set_tokimeki(tokimeki + 5)
			else:
				show_dialog(["That's a secret."])
				set_tokimeki(tokimeki - 5)
		"Her phone number":
			if tokimeki >= 90:
				show_dialog(["Let me write it down for you."], ['happy'])
				set_tokimeki(tokimeki + 5)
				phone_number_get = true
			elif tokimeki >= 60:
				show_dialog(["I'm more comfortable chatting."])
				set_tokimeki(tokimeki + 1)
			else:
				show_dialog(["I don't have a phone (lie)."])
				set_tokimeki(tokimeki - 5)
		"Her three sizes":
			if tokimeki >= 100:
				show_dialog(['...','... ... ...','It\'s B39" W23" H36"...'],['sad','sad','neutral'])
				set_tokimeki(tokimeki + 1)
				bwh_get = true
			elif tokimeki >= 75:
				show_dialog(["Noooooo..."],['sad'])
				set_tokimeki(tokimeki - 1)
			else:
				show_dialog(["I don't think you need to know that."],['angry'])
				set_tokimeki(tokimeki - 10)
			
		"Talk about the weather":
			show_dialog(["It's been getting colder recently."])
			set_tokimeki(tokimeki + 1)
		"Her favorite food":
			show_dialog(["I love tacos!"], ['happy'])
			set_tokimeki(tokimeki + 5)
		"Her work":
			show_dialog(["A lot of things happened,\nbut at least I still have a job."])
			set_tokimeki(tokimeki + 2)
		"What she will drink":
			show_dialog(["I'd like some black tea please."], ['happy'])
			set_tokimeki(tokimeki + 2)
		"Hopes and dreams":
			show_dialog(["I want to become a doctor and heal everyone!"], ['happy'])
			set_tokimeki(tokimeki + 5)
			
		"Discuss ethics":
			var tmp = pop_random(ethics_lines)
			show_dialog(tmp, ['happy'])
			set_tokimeki(tokimeki + 5)
		"Discuss fashion":
			var tmp = pop_random(fashion_lines)
			show_dialog(tmp)
			set_tokimeki(tokimeki + 2)
		"Discuss athletics":
			var tmp = pop_random(athletics_lines)
			show_dialog(tmp, ['happy'])
			set_tokimeki(tokimeki + 5)
		"Discuss STEM":
			var tmp = pop_random(stem_lines)
			show_dialog(tmp)
			set_tokimeki(tokimeki + 2)
		"Discuss medicine":
			var tmp = pop_random(medicine_lines, ["That's wonderful."])
			show_dialog(tmp, ['happy'])
			set_tokimeki(tokimeki + 10)
		"Discuss humanities":
			var tmp = pop_random(culture_lines)
			show_dialog(tmp)
			set_tokimeki(tokimeki + 2)
		"Discuss video games":
			var tmp = pop_random(video_games_lines,["I love video games."])
			show_dialog(tmp, ['happy'])
			set_tokimeki(tokimeki + 10)
		"Discuss rock music":
			var tmp = pop_random(rock_lines,["People who listen to rock music are scary."])
			show_dialog(tmp, ['angry'])
			set_tokimeki(tokimeki - 5)
		"Discuss jazz music":
			var tmp = pop_random(jazz_lines)
			show_dialog(tmp)
			set_tokimeki(tokimeki + 2)
		"Discuss classical music":
			var tmp = pop_random(classic_lines)
			show_dialog(tmp, ['happy'])
			set_tokimeki(tokimeki + 5)
		"Discuss painting":
			var tmp = pop_random(painting_lines)
			show_dialog(tmp)
			set_tokimeki(tokimeki + 2)
		"Discuss gardening":
			var tmp = pop_random(gardening_lines,["That's incredible."])
			show_dialog(tmp)
			set_tokimeki(tokimeki + 10)

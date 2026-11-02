extends Node

const data_file = 'user://data.json'
var hiscores : Array
var score : int

func _ready() -> void:
	global.load_data()

func default_hiscores():
	# Default hiscore list
	var default_scores = [
		[12000,'P☆S'],
		[8000,'NAO'],
		[6000,'YUI'],
		[5000,'MAY'],
		[4000,'EVE'],
		[3000,'ANA'],
		[2000,'MIU'],
		[1000,'ADA'],
		[500,'MEI'],
		[100,'KAT']]
	return default_scores
	
func write_default_data():
	if not FileAccess.file_exists(data_file):
		print('Setting up initial save data')
		var dict = {}
		dict['hiscores'] = default_hiscores()
		var file = FileAccess.open(data_file, FileAccess.WRITE)
		file.store_string(JSON.stringify(dict))
		file.close()
		
func save_data():
	print('Saving data...')
	var dict = {}
	dict['hiscores'] = hiscores
	var file = FileAccess.open(data_file, FileAccess.WRITE)
	file.store_string(JSON.stringify(dict))
	file.close()
	print('Finished saving!')

func load_data():
	if !FileAccess.file_exists(data_file):
		write_default_data()
	# THIS IS NOT SAFE
	# IF THE PLAYER HAS EDITED OR CORRUPTED THEIR FILE
	var file = FileAccess.open(data_file, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var dict = JSON.parse_string(content)
	hiscores = dict['hiscores']
	
func play_flip():
	$Flip.play()
	
func play_incorrect():
	$Incorrect.play()
	
func play_punch():
	$Punch.play()
	
func play_coin():
	$Coin.play()
	
func play_bgm():
	$BGM.play()
	
func play_bgm2():
	$BGM2.play()
	
func fade_bgm():
	var tween = self.create_tween()
	tween.tween_property($BGM2,"volume_db",-20,3.0)
	tween.tween_callback(stop_bgm2)
	tween.tween_property($BGM2,"volume_db",0.0,0.0)
	
func stop_bgm():
	$BGM.stop()
	
func stop_bgm2():
	$BGM2.stop()

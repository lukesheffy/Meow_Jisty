extends Node2D

@export var enemy_scene: PackedScene
@onready var spawn_location: PathFollow2D = $player/Camera2D/SpawnPath/SpawnLocation
@onready var spawn_timer: Timer = $SpawnTimer
var score = 0
var combo = 0

	

var max_combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0

var bpm = 180

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm


var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0


func _ready() -> void:
	print("LEVEL 2 READY")
	randomize()
	$Conductor.beat.connect(_on_conductor_beat)
	$Conductor.measure.connect(_on_conductor_measure)
	$Conductor.play_with_beat_offset(7.75)
	if enemy_scene == null:
		print("ERROR: enemy_scene is NOT assigned in the Inspector!")

func _on_spawn_timer_timeout() -> void:
	print("Timer ticked!")
	
	if enemy_scene == null:
		print("Cannot spawn: enemy_scene is null.")
		return


func _on_Conductor_measure(position):
	print("measure signal: ", position)
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)


	var enemy = enemy_scene.instantiate()
	spawn_location.progress_ratio = 0.5
	enemy.global_position = spawn_location.global_position
	
	print("Spawning enemy at position: ", enemy.global_position)
	get_tree().current_scene.add_child(enemy)
	
	
func _spawn_notes(to_spawn):
	print("_spawn_notes called with: ", to_spawn)
	if to_spawn > 0:
		
		var enemy = enemy_scene.instantiate()
		spawn_location.progress_ratio = 0.1
		enemy.global_position = spawn_location.global_position
		enemy.global_position.y += 150 
		print("enemy spawned at: ", enemy.global_position)
		get_tree().current_scene.add_child(enemy)
		
		
		
func increment_score(by):
	if by > 0:
		combo += 1
	else:
		combo = 0
	print("increment_score called with by=", by, " → combo now: ", combo, " score now: ", score + by * combo)
	
	if by == 3:
		great += 1
	elif by == 2:
		good += 1
	elif by == 1:
		okay += 1
	else:
		missed += 1
	
	
	
func _on_conductor_beat(position: Variant) -> void:
	print("beat signal: ", position)
	song_position_in_beats = position
	if song_position_in_beats > 36:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 98:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 132:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 162:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 194:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 228:
		spawn_1_beat = 0
		spawn_2_beat = 2
	if song_position_in_beats > 232:
		Globals.set_score(score)
		Globals.combo = max_combo
		Globals.great = great
		Globals.good = good
		Globals.okay = okay
		Globals.missed = missed
		if get_tree().change_scene_to_file("res://Scenes/End.tscn") != OK:
			print("Error changing scene to End")


func _on_conductor_measure(position: Variant) -> void:
	print("measure signal: ", position)
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)
		

func _on_end_timer_timeout() -> void:
	print("End_timer finished!")
	get_tree().change_scene_to_file("res://winner.tscn")

extends Node2D

var won = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://opening_talk.tscn")
	$AudioStreamPlayer.stop()
	
	


func _on_audio_stream_player_finished() -> void:
	$"winning_page".visible = true

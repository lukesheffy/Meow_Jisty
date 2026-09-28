extends AnimatedSprite2D

var perfect = false
var good = false
var okay = false
var current_note = null

@export var input = "hit_z"
@onready var level = get_tree().current_scene

func _unhandled_input(event):
	if event.is_action(input):
		if event.is_action_pressed(input, false):
			print("hit pressed — current_note: ", current_note, " perfect: ", perfect, " good: ", good, " okay: ", okay)
			if current_note != null:
				if perfect:
					get_parent().increment_score(3)
					current_note.destroy(3)
				elif good:
					get_parent().increment_score(2)
					current_note.destroy(2)
				elif okay:
					get_parent().increment_score(1)
					current_note.destroy(1)
				_reset()
			else:
				level.increment_score(3)
		if event.is_action_pressed(input):
			frame = 1
		elif event.is_action_released(input):
			$PushTimer.start()


func _on_PerfectArea_area_entered(area):
	if area.is_in_group("enemy"):
		perfect = true


func _on_PerfectArea_area_exited(area):
	if area.is_in_group("enemy"):
		perfect = false


func _on_GoodArea_area_entered(area):
	if area.is_in_group("enemy"):
		good = true


func _on_GoodArea_area_exited(area):
	if area.is_in_group("enemy"):
		good = false


func _on_OkayArea_area_entered(area):
	if area.is_in_group("enemy"):
		okay = true
		current_note = area


func _on_OkayArea_area_exited(area):
	if area.is_in_group("enemy"):
		okay = false
		current_note = null


func _on_PushTimer_timeout():
	frame = 0


func _reset():
	current_note = null
	perfect = false
	good = false
	okay = false

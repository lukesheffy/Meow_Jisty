extends CharacterBody2D
class_name Enemy


var SPEED = -500.0
const JUMP_VELOCITY = -400.0
var YSPEED = -200.0
var is_dead = false
var in_player = false
var health = 100


func _physics_process(delta: float) -> void:
	if position.x < -40:
		check_accuracy()
		queue_free()
	
	
	
	# Add the gravity.
	if not is_on_floor() and not is_dead:
		velocity += get_gravity() * delta
	elif is_dead:
		$"AnimatedSprite2D".animation = "hurt"

		velocity.y = YSPEED
		SPEED = -300
	
	velocity.x = SPEED
	move_and_slide()
		
	if is_dead:
		$"AnimatedSprite2D".animation = "hurt"
		SPEED = -300
		
	move_and_slide()
	
	
func take_damage() -> void:
	is_dead = true
	
func check_accuracy() -> void:
	var diff = position.x - $"../player".position.x
	if diff > -20 and diff < 100:
		$"../player".indicator = "Perfect"
		$"../player".score += 300
		$"../KillTimer".start()
	elif diff < -20 and diff > -100:
		$"../player".indicator = "Okay"
		$"../player".score += 100
		$"../KillTimer".start()
	elif diff < -20:
		$"../player".indicator = "Miss"

func _on_attack_area_body_entered(body: Node2D) -> void:
	
	if body is Player:
		in_player = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	in_player = false
	
func set_dead(isDead: bool) -> void:
	is_dead = isDead


func _on_kill_timer_timeout() -> void:
	queue_free()
	pass

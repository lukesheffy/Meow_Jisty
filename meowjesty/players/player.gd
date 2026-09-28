extends CharacterBody2D
class_name Player

@export var ui: CanvasLayer
@onready var attack_area: Area2D = $AttackArea
const SPEED = 800.0
const JUMP_VELOCITY = -600.0
var combo = 0
var score = 0
var indicator = "Perfect"



var last_animation = "running"

func _physics_process(delta: float) -> void:
	ui.set_score(score, indicator)
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += 1.2 * get_gravity() * delta
	elif ($AnimatedSprite2D.animation == "jumping" || last_animation == "jumping"):
		last_animation = $AnimatedSprite2D.animation
		$AnimatedSprite2D.play("running")
		
	# Attack Input
	if Input.is_action_just_pressed("hit_z") or Input.is_action_just_pressed("hit_x"):
		if $AnimatedSprite2D.animation != "attack":
			last_animation = $AnimatedSprite2D.animation
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("attack")
		
		deal_damage()

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if $AnimatedSprite2D.animation != "jumping":
			last_animation = $AnimatedSprite2D.animation
		$AnimatedSprite2D.play("jumping")
		
	# Continuously moving
	velocity.x = SPEED

	move_and_slide()

func deal_damage() -> void:
	var overlapping_bodies = attack_area.get_overlapping_bodies()
	
	var closest_enemy: Node2D = null
	var shortest_distance: float = INF

	for body in overlapping_bodies:
		if body is Enemy:
			var distance = global_position.distance_squared_to(body.global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				closest_enemy = body

	if closest_enemy != null:
		print(closest_enemy.position.x - position.x)
		if not closest_enemy.is_dead:
			closest_enemy.check_accuracy()
			closest_enemy.take_damage()

		

func _on_animated_sprite_2d_animation_finished() -> void:
	if is_on_floor():
		$AnimatedSprite2D.play("running")

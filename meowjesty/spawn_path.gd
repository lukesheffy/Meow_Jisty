extends Node2D

# Preload your enemy scene so Godot can instantiate it
@export var enemy_scene: PackedScene

@onready var spawn_location: PathFollow2D = $SpawnPath/SpawnLocation
@onready var spawn_timer: Timer = $SpawnTimer

func _on_spawn_timer_timeout() -> void:
	# Instantiate a new enemy scene
	var enemy = enemy_scene.instantiate()

	# Pick a random point along the Path2D curve
	spawn_location.progress_ratio = randf()

	# Set the enemy's position to the chosen off-screen spot
	enemy.global_position = spawn_location.global_position

	# Add the enemy scene to your level node tree
	add_child(enemy)

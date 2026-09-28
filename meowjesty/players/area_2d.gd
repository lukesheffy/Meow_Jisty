# script attached to the enemy's child Area2D (in "enemy" group)
extends Area2D

func destroy(score_tier: int) -> void:
	get_parent().take_damage()
	# optionally: play a hit effect/sound before freeing
	await get_tree().create_timer(0.2).timeout  # let hurt animation show briefly, if wanted
	get_parent().queue_free()

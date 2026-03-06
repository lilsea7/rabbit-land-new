extends NodeState

@export var player: Player
@export var animate_sprite_2d: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if !animate_sprite_2d.is_playing():
		transition.emit("Idle")


func _on_enter() -> void:
	if player.player_direction == Vector2.UP:
		animate_sprite_2d.play("tilling_back")
	elif player.player_direction == Vector2.DOWN:
		animate_sprite_2d.play("tilling_front")
	elif player.player_direction == Vector2.LEFT:
		animate_sprite_2d.play("tilling_left")	
	elif player.player_direction == Vector2.RIGHT:
		animate_sprite_2d.play("tilling_right")
	else:
		animate_sprite_2d.play("tilling_front")

func _on_exit() -> void:
	animate_sprite_2d.stop()

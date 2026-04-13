extends Timer

enum SFXType { CHICKEN, COW }

@export var sfx_type: SFXType = SFXType.CHICKEN

func _ready() -> void:
	wait_time = randf_range(3.0, 8.0)
	one_shot = false
	start()

func _on_timeout() -> void:
	var parent = get_parent()
	if not parent is Node2D:
		return
	
	match sfx_type:
		SFXType.CHICKEN:
			SoundManager.play_chicken_sfx(parent.global_position)
		SFXType.COW:
			SoundManager.play_cow_sfx(parent.global_position)
	
	wait_time = randf_range(3.0, 8.0)

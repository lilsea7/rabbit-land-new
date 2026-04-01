extends NodeState

func _on_enter() -> void:
	# Có thể play animation ăn nếu có
	print("Chicken: Entering Eating state")

func _on_exit() -> void:
	pass

func _on_process(delta: float) -> void:
	pass

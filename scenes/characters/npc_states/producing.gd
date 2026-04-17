extends NodeState

func _on_enter() -> void:
	print("Pet: Entering Producing state")
	# Play animation đẻ trứng nếu có

func _on_exit() -> void:
	pass

func _on_process(delta: float) -> void:
	pass

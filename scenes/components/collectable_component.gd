class_name CollactableComponent
extends Area2D

@export var collactable_name: String

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		InventoryManager.add_collectable(collactable_name)
		print("Collected: " + collactable_name)
		get_parent().queue_free()

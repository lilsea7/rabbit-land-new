class_name PlantSaveDataResource
extends Resource

@export var scene_path: String = ""
@export var position: Vector2 = Vector2.ZERO
@export var extra_data: Dictionary = {}

func _save_data(plant_node: Node2D) -> void:
	scene_path = plant_node.scene_file_path
	position = plant_node.position
	# Có thể thêm growth_state sau này
	print("Đã lưu cây: ", scene_path, " tại ", position)

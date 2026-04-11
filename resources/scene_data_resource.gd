class_name SceneDataResource
extends NodeDataResource

@export var node_name: String
@export var scene_file_path: String


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	node_name = node.name
	
	# tránh lỗi nếu node không có scene_file_path
	if "scene_file_path" in node:
		scene_file_path = node.scene_file_path


func _load_data(window: Window) -> void:
	var parent_node: Node = null   # 🔥 FIX: dùng Node thay vì Node2D
	var scene_node: Node2D = null
	
	# ===== Lấy parent node =====
	if parent_node_path != null:
		var temp_node = window.get_node_or_null(parent_node_path)
		
		if temp_node != null:
			parent_node = temp_node
		else:
			push_warning("Parent node not found: " + str(parent_node_path))
	
	# ===== Load scene =====
	if scene_file_path != "":
		var scene_resource = load(scene_file_path)
		
		if scene_resource == null:
			push_error("Failed to load scene: " + scene_file_path)
			return
		
		var instance = scene_resource.instantiate()
		
		# 🔥 FIX: kiểm tra kiểu trước khi cast
		if instance is Node2D:
			scene_node = instance
		else:
			push_error("Loaded scene is not Node2D: " + scene_file_path)
			return
	
	# ===== Add vào scene =====
	if parent_node != null and scene_node != null:
		scene_node.name = node_name
		scene_node.global_position = global_position
		
		parent_node.add_child(scene_node)
	else:
		push_warning("Load failed: parent_node or scene_node is null")

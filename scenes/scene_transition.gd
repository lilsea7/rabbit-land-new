# scene_transition.gd
extends CanvasLayer

var color_rect: ColorRect
signal transition_finished

func _ready() -> void:
	color_rect = get_node("ColorRect")
	if color_rect:
		color_rect.modulate.a = 0.0

func fade_to_scene(scene_path: String, spawn_point_name: String = "SpawnPoint") -> void:
	var all_players = get_tree().get_nodes_in_group("player")
	print("🔍 Trước khi fade - Số player: ", all_players.size())
	for p in all_players:
		print("   ", p.name, " | Parent: ", p.get_parent().name, " | Visible: ", p.visible)
	if not color_rect:
		return

	# Lấy player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.visible = false

	# Fade đen
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	await tween.finished

	# Tìm LevelRoot
	var level_root = get_tree().root.find_child("LevelRoot", true, false)
	if not level_root:
		print("⚠️ Không tìm thấy LevelRoot!")
		return

	# Xóa scene cũ
	for child in level_root.get_children():
		child.queue_free()

	await get_tree().process_frame
	await get_tree().process_frame

	# Load scene mới
	var new_scene = load(scene_path).instantiate()
	level_root.add_child(new_scene)

	await get_tree().process_frame
	await get_tree().process_frame

	# Chỉ di chuyển player đến spawn point
	if player and is_instance_valid(player):
		var spawn_point = new_scene.find_child(spawn_point_name, true, false)
		if spawn_point:
			player.global_position = spawn_point.global_position
			print("✅ Player spawn tại: ", spawn_point.global_position)
		else:
			print("⚠️ Không tìm thấy SpawnPoint: ", spawn_point_name)

		player.visible = true

		# Reset camera
		var camera = player.get_node_or_null("Camera2D")
		if camera:
			camera.reset_smoothing()
			camera.force_update_scroll()

	# Fade sáng lại
	var tween2 = create_tween()
	tween2.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	await tween2.finished

	transition_finished.emit()

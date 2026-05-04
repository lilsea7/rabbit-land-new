extends CanvasLayer

var color_rect: ColorRect
var _is_transitioning: bool = false
signal transition_finished

func _ready() -> void:
	color_rect = get_node("ColorRect")
	if color_rect:
		color_rect.modulate.a = 0.0

func fade_to_scene(scene_path: String, spawn_point_name: String = "SpawnPoint") -> void:
	# Chặn gọi nhiều lần cùng lúc
	if _is_transitioning:
		print("⚠️ Đang transition, bỏ qua lệnh gọi thêm!")
		return
	_is_transitioning = true

	if not color_rect:
		_is_transitioning = false
		return

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.visible = false
	var guide = get_tree().root.find_child("Guide", true, false)
	if guide:
		guide.visible = false

	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	await tween.finished

	var level_root = get_tree().root.find_child("LevelRoot", true, false)
	if not level_root:
		print("⚠️ Không tìm thấy LevelRoot!")
		_is_transitioning = false
		return

	# Xóa scene cũ — chờ đủ frame để queue_free hoàn tất
	for child in level_root.get_children():
		child.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame  # thêm 1 frame nữa

	var new_scene = load(scene_path).instantiate()
	level_root.add_child(new_scene)
	await get_tree().process_frame
	await get_tree().process_frame

	# Load lại state khi ra ngoài farm
	if spawn_point_name == "FarmSpawnPoint":
		SaveGameManager.load_game()
		await get_tree().process_frame
		await get_tree().process_frame
		print("✅ Đã load game state khi ra ngoài farm")

	if player and is_instance_valid(player):
		var spawn_point = get_tree().root.find_child(spawn_point_name, true, false)
		if spawn_point:
			player.global_position = spawn_point.global_position
			print("✅ Player spawn tại: ", spawn_point.global_position)
		else:
			print("⚠️ Không tìm thấy SpawnPoint: ", spawn_point_name)
		player.visible = true
		if spawn_point_name == "FarmSpawnPoint":
			if guide:
				guide.visible = true
		var camera = player.get_node_or_null("Camera2D")
		if camera:
			camera.reset_smoothing()
			camera.force_update_scroll()

	var tween2 = create_tween()
	tween2.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	await tween2.finished
	transition_finished.emit()
	_is_transitioning = false  # reset flag sau khi xong

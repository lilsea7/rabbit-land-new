extends Node

const SAVE_PATH = "user://save_game.save"
var allow_save_game: bool = true

signal game_saved
signal game_loaded

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game") and allow_save_game:
		save_game()

func save_game() -> void:
	if not allow_save_game:
		print("⚠️ Save game đang bị tắt!")
		return

	var save_level_data = get_tree().get_first_node_in_group("save_level_data_component")
	if save_level_data:
		save_level_data.save_game()
		print("💾 Game đã được lưu thành công!")
		game_saved.emit()
	else:
		push_error("❌ Không tìm thấy SaveLevelDataComponent!")

func load_game() -> void:
	var save_level_data = get_tree().get_first_node_in_group("save_level_data_component")
	if save_level_data:
		save_level_data.load_game()
		print("✅ Game đã được load thành công!")
		game_loaded.emit()
	else:
		push_error("❌ Không tìm thấy SaveLevelDataComponent!")

func delete_save() -> void:
	var path = "user://game_data/save_game_data.tres"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("🗑️ Đã xóa file save")

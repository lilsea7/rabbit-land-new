extends Node

var game_menu_screen = preload("res://scenes/ui/game_menu_screen.tscn")
var intro_screen = preload("res://scenes/ui/intro_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()

# ================== KHỞI ĐỘNG GAME ==================
func start_game() -> void:
	print("🚀 Bắt đầu game mới...")

	# Chỉ hiển thị intro nếu chưa có file save
	var save_path = "user://game_data/save_game_data.tres"
	if not FileAccess.file_exists(save_path):
		_show_intro()
		return

	_load_main_game()

func _show_intro() -> void:
	var intro = intro_screen.instantiate()
	get_tree().root.add_child(intro)

func _load_main_game() -> void:
	SceneManager.load_main_scene_container()
	SceneManager.load_level("Level1")

	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout

	SaveGameManager.load_game()
	SaveGameManager.allow_save_game = true

	print("✅ Game đã khởi động hoàn tất!")

# ================== THOÁT GAME ==================
func exit_game() -> void:
	SaveGameManager.save_game()
	print("💾 Đã lưu game trước khi thoát.")
	get_tree().quit()

# ================== HIỂN THỊ MENU ==================
func show_game_menu_screen() -> void:
	var game_menu_screen_instance = game_menu_screen.instantiate()
	get_tree().root.add_child(game_menu_screen_instance)
	print("📋 Đã mở Game Menu Screen")

# ================== HÀM SAVE / LOAD THỦ CÔNG ==================
func save_game() -> void:
	SaveGameManager.save_game()

func load_game() -> void:
	SaveGameManager.load_game()

# ================== RESET GAME ==================
func reset_game() -> void:
	SaveGameManager.delete_save()
	print("🔄 Game đã được reset!")

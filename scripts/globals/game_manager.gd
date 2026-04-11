#extends Node
#
extends Node

var game_menu_screen = preload("res://scenes/ui/game_menu_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()

# ================== KHỞI ĐỘNG GAME ==================
func start_game() -> void:
	print("🚀 Bắt đầu game mới...")
	
	SceneManager.load_main_scene_container()
	SceneManager.load_level("Level1")
	
	# Đợi nhiều frame hơn để đảm bảo tất cả node đã load xong
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	# Đợi 0.5 giây để chắc chắn scene load xong
	await get_tree().create_timer(0.5).timeout
	SaveGameManager.load_game()
	
	SaveGameManager.allow_save_game = true
	
	print("✅ Game đã khởi động hoàn tất!")

# ================== THOÁT GAME ==================
func exit_game() -> void:
	# Lưu game trước khi thoát (tùy chọn nhưng nên có)
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

# Hàm reset game (dùng để test)
func reset_game() -> void:
	SaveGameManager.delete_save()
	# Có thể reload scene hoặc reset các manager
	print("🔄 Game đã được reset!")

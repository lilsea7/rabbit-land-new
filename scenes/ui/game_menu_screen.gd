extends CanvasLayer

@onready var save_game_button: Button = $MarginContainer/VBoxContainer/SaveGameButton
@onready var setting_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/SettingButton
@onready var help_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/HelpButton
@onready var about_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/AboutButton

@onready var setting_popup: CanvasLayer = $SettingPopup
@onready var help_popup: CanvasLayer = $HelpPopup
@onready var about_popup: CanvasLayer = $AboutPopup

@onready var music_slider: HSlider = $SettingPopup/Control/PanelContainer/MarginContainer/VBoxContainer/MusicRow/MusicSlider
@onready var sfx_slider: HSlider = $SettingPopup/Control/PanelContainer/MarginContainer/VBoxContainer/SFXRow/SFXSlider

@onready var close_setting: Button = $SettingPopup/Control/CloseSetting
@onready var close_help: Button = $HelpPopup/Control/CloseHelp
@onready var close_about: Button = $AboutPopup/Control/CloseAbout

func _ready() -> void:
	setting_button.pressed.connect(_on_setting_button_pressed)
	help_button.pressed.connect(_on_help_button_pressed)
	about_button.pressed.connect(_on_about_button_pressed)
	
	if close_setting:
		close_setting.pressed.connect(_on_close_setting_pressed)
	else:
		push_error("CloseSetting không tìm thấy!")
	
	if close_help:
		close_help.pressed.connect(_on_close_help_pressed)
	else:
		push_error("CloseHelp không tìm thấy!")
	
	if close_about:
		close_about.pressed.connect(_on_close_about_pressed)
	else:
		push_error("CloseAbout không tìm thấy!")
	
	save_game_button.disabled = !SaveGameManager.allow_save_game
	save_game_button.focus_mode = Control.FOCUS_ALL if SaveGameManager.allow_save_game else Control.FOCUS_NONE
	
	if setting_popup: setting_popup.visible = false
	if help_popup: help_popup.visible = false
	if about_popup: about_popup.visible = false
	

func _on_setting_button_pressed() -> void:
	if setting_popup:
		setting_popup.visible = true
		print("✅ Mở Setting Popup")
	else:
		push_error("Không mở được SettingPopup!")

func _on_help_button_pressed() -> void:
	if help_popup:
		help_popup.visible = true
		print("✅ Mở Help Popup")
	else:
		push_error("Không mở được HelpPopup!")

func _on_about_button_pressed() -> void:
	if about_popup:
		about_popup.visible = true
		print("✅ Mở About Popup")
	else:
		push_error("Không mở được AboutPopup!")

func _on_close_setting_pressed() -> void:
	SoundManager.play_button_click()
	if setting_popup:
		setting_popup.visible = false
		print("Đóng Setting Popup")

func _on_close_help_pressed() -> void:
	SoundManager.play_button_click()
	if help_popup:
		help_popup.visible = false
		print("Đóng Help Popup")

func _on_close_about_pressed() -> void:
	SoundManager.play_button_click()
	if about_popup:
		about_popup.visible = false
		print("Đóng About Popup")

# ── Xử lý âm lượng (nếu cần kết nối từ code thay vì editor) ──
func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

# ── Các hàm cũ của bạn ──
func _on_start_game_button_pressed() -> void:
	GameManager.start_game()
	queue_free()

func _on_save_game_button_pressed() -> void:
	SaveGameManager.save_game()

func _on_exit_game_button_pressed() -> void:
	GameManager.exit_game()

extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var title_label: Label = $ColorRect/VBoxContainer/TitleLabel
@onready var level_label: Label = $ColorRect/VBoxContainer/LevelLabel
@onready var unlock_label: Label = $ColorRect/VBoxContainer/UnlockLabel
@onready var close_button: Button = $ColorRect/VBoxContainer/CloseButton

func _ready() -> void:
	hide()  # Ẩn ban đầu
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

# Hiển thị Level Up
func show_level_up(new_level: int, unlock_text: String = "") -> void:
	level_label.text = "Level " + str(new_level)
	unlock_label.text = "Mở khóa: " + unlock_text if unlock_text != "" else ""
	
	visible = true
	
	# Animation fade in
	color_rect.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.4)
	
	# Tự động ẩn sau 4 giây
	await get_tree().create_timer(4.0).timeout
	hide_with_fade()

func hide_with_fade() -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 0.4)
	await tween.finished
	visible = false

func _on_close_pressed() -> void:
	hide_with_fade()

# level_ui.gd
extends Panel

@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var exp_bar: ProgressBar = $VBoxContainer/ExpBar
@onready var exp_label: Label = $VBoxContainer/ExpLabel   # ← Tạo Label mới để hiển thị "6/50"

func _ready() -> void:
	LevelManager.exp_changed.connect(_on_exp_changed)
	LevelManager.level_up.connect(_on_level_up)
	
	# Tạo Label hiển thị exp nếu chưa có
	if not has_node("VBoxContainer/ExpLabel"):
		exp_label = Label.new()
		exp_label.name = "ExpLabel"
		$VBoxContainer.add_child(exp_label)
	
	update_ui()

func update_ui() -> void:
	level_label.text = "Level " + str(LevelManager.current_level)
	
	var current = LevelManager.current_exp
	var needed = LevelManager.get_exp_to_next_level()
	
	exp_bar.max_value = needed
	exp_bar.value = current
	
	# Hiển thị dạng phân số
	exp_label.text = str(current) + " / " + str(needed)
	
	# Tùy chọn: Ẩn thanh ProgressBar nếu bạn chỉ muốn hiển thị số
	# exp_bar.visible = false

func _on_exp_changed(current_exp: int, exp_to_next: int) -> void:
	exp_bar.max_value = exp_to_next
	exp_bar.value = current_exp
	exp_label.text = str(current_exp) + " / " + str(exp_to_next)

func _on_level_up(new_level: int) -> void:
	level_label.text = "Level " + str(new_level)
	# Hiệu ứng nổi bật
	var tween = create_tween()
	tween.tween_property(level_label, "modulate", Color.YELLOW, 0.3)
	tween.tween_property(level_label, "modulate", Color.WHITE, 0.6)

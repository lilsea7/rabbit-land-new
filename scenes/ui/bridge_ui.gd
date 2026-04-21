# bridge_ui.gd
extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var log_label: Label = $PanelContainer/VBox/LogRow/LogLabel
@onready var stone_label: Label = $PanelContainer/VBox/StoneRow/StoneLabel
@onready var confirm_btn: Button = $PanelContainer/VBox/ConfirmBtn

var current_blocker: Node2D = null

func _ready() -> void:
	hide()  # ẩn cả CanvasLayer thay vì chỉ panel
	confirm_btn.pressed.connect(_on_confirm_pressed)

func open(blocker: Node2D) -> void:
	if current_blocker != null and current_blocker != blocker:
		close()
	current_blocker = blocker
	_refresh()
	show()  # hiện cả CanvasLayer

func close() -> void:
	hide()  # ẩn cả CanvasLayer
	current_blocker = null

func _refresh() -> void:
	if current_blocker == null:
		return

	var have_log   = InventoryManager.get_quantity("log")
	var have_stone = InventoryManager.get_quantity("stone")
	var need_log   = current_blocker.required_log
	var need_stone = current_blocker.required_stone

	log_label.text   = "%d / %d" % [have_log,   need_log]
	stone_label.text = "%d / %d" % [have_stone, need_stone]

	log_label.modulate   = Color.GREEN if have_log   >= need_log   else Color.RED
	stone_label.modulate = Color.GREEN if have_stone >= need_stone else Color.RED

	var can_build = have_log >= need_log and have_stone >= need_stone
	confirm_btn.disabled = not can_build
	# Button luôn hiện, chỉ đổi độ mờ khi không đủ
	#confirm_btn.modulate = Color(1, 1, 1, 1.0) if can_build else Color(1, 1, 1, 0.4)

func _on_confirm_pressed() -> void:
	if current_blocker:
		current_blocker.try_unlock()

func show_success() -> void:
	confirm_btn.disabled = true
	await get_tree().create_timer(1.0).timeout
	close()

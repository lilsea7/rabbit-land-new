extends Node2D

@export var required_log: int = 1
@export var required_stone: int = 1

@onready var interactable: InteractableComponent = $InteractableComponent
@onready var interact_label = $InteractableLabelComponent
@onready var blocker: StaticBody2D = $Blocker

var player_ref: Player = null

func _ready() -> void:
	interact_label.hide()
	interactable.interactable_activated.connect(_on_player_enter)
	interactable.interactable_deactivated.connect(_on_player_exit)

func _on_player_enter() -> void:
	player_ref = get_tree().get_first_node_in_group("player")
	interact_label.show()
	if player_ref:
		player_ref.set_interact_target(self)

func _on_player_exit() -> void:
	interact_label.hide()
	if player_ref:
		player_ref.clear_interact_target(self)  # hủy target
	player_ref = null
	# Đóng UI nếu đang mở
	var bridge_ui = get_tree().get_first_node_in_group("bridge_ui")
	if bridge_ui:
		bridge_ui.close()

# Player sẽ gọi hàm này khi bấm E
func interact() -> void:
	var bridge_ui = get_tree().get_first_node_in_group("bridge_ui")
	print("Bridge UI found: ", bridge_ui)  # xem có null không
	if bridge_ui:
		bridge_ui.open(self)

func try_unlock() -> void:
	if InventoryManager.has_enough("log", required_log) and \
		InventoryManager.has_enough("stone", required_stone):
		InventoryManager.remove_collectable("log", required_log)
		InventoryManager.remove_collectable("stone", required_stone)
		_unlock()

func _unlock() -> void:
	var bridge_ui = get_tree().get_first_node_in_group("bridge_ui")
	if bridge_ui:
		bridge_ui.show_success()
	blocker.get_child(0).set_deferred("disabled", true)
	interact_label.hide()
	if player_ref:
		player_ref.clear_interact_target(self)
	await get_tree().create_timer(1.5).timeout
	queue_free()

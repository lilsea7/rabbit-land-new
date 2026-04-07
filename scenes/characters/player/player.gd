class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2 = Vector2.ZERO

var interact_target: Node = null

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)

func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool

func _process(delta):
	handle_interact()

func handle_interact():
	if Input.is_action_just_pressed("interact"):
		interact()

func interact():
	if interact_target == null:
		print("❌ Không có gì để tương tác")
		return
	
	print("👉 Tương tác với:", interact_target.name)
	
	# Mở FoodMenu nếu là gà
	if interact_target.has_method("interact"):
		interact_target.interact()
	else:
		print("Tương tác với vật khác (chưa xử lý)")

func set_interact_target(target: Node):
	interact_target = target

func clear_interact_target(target: Node):
	if interact_target == target:
		interact_target = null

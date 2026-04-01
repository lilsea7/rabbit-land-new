#class_name Player
#extends CharacterBody2D
#
## ================== NODE ==================
#@onready var hit_component: HitComponent = $HitComponent
#
## ================== TOOL (GIỮ NGUYÊN) ==================
#@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
#
## ================== GIỮ LOGIC CŨ ==================
#var player_direction: Vector2 = Vector2.ZERO
#
## ================== INTERACT (THÊM MỚI) ==================
#var interact_target: Node = null
#
## ================== READY ==================
#func _ready() -> void:
	#ToolManager.tool_selected.connect(on_tool_selected)
#
## ================== TOOL CHANGE ==================
#func on_tool_selected(tool: DataTypes.Tools) -> void:
	#current_tool = tool
	#hit_component.current_tool = tool
#
## ================== PROCESS ==================
#func _process(delta):
	#handle_interact()   # 👈 THÊM (không ảnh hưởng logic cũ)
#
## ================== INTERACT ==================
#func handle_interact():
	#if Input.is_action_just_pressed("interact"):
		#interact()
#
#func interact():
	#if interact_target == null:
		#print("❌ Không có gì để tương tác")
		#return
	#
	#print("👉 Tương tác với:", interact_target.name)
#
	## Gọi feed nếu là gà
	#if interact_target.has_method("feed"):
		#interact_target.feed()
#
## ================== SET TARGET ==================
#func set_interact_target(target: Node):
	#interact_target = target
#
#func clear_interact_target(target: Node):
	#if interact_target == target:
		#interact_target = null

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

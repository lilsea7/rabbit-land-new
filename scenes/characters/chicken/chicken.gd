extends NonPlayableCharacter
class_name Chicken

# ================== NODE ==================
@onready var egg_timer: Timer = $EggProductionTimer
@onready var interaction_area: Area2D = $InteractionArea
@onready var egg_spawn_point: Marker2D = $EggSpawnPoint
@onready var state_machine: NodeStateMachine = $StateMachine

# ================== CONFIG ==================
@export var time_to_lay_egg: float = 8.0   # Dễ test

# ================== STATE ==================
var is_fed: bool = false
var player_in_range: bool = false
var current_food_menu = null

# ================== RESOURCE ==================
var egg_scene: PackedScene = preload("res://scenes/object/egg.tscn")
var food_menu_scene: PackedScene = preload("res://scenes/ui/food_menu.tscn")

# ================== READY ==================
func _ready() -> void:
	print("🐔 Chicken _ready()")
	
	egg_timer.one_shot = true
	egg_timer.timeout.connect(_on_egg_timer_timeout)   # Đảm bảo kết nối
	
	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)

# ================== PLAYER DETECT ==================
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("👉 Player vào vùng gà")
		player_in_range = true
		body.set_interact_target(self)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		print("👈 Player rời vùng gà")
		player_in_range = false
		body.clear_interact_target(self)
		
		if current_food_menu and is_instance_valid(current_food_menu):
			current_food_menu.close_menu()
			current_food_menu.queue_free()
			current_food_menu = null

# ================== INTERACT ==================
func interact() -> void:
	if not player_in_range:
		return
	if current_food_menu and is_instance_valid(current_food_menu):
		print("⚠️ FoodMenu đã tồn tại")
		return
	
	print("🐔 Player bấm E → Mở Food Menu")
	
	var food_menu = food_menu_scene.instantiate()
	get_tree().root.add_child(food_menu)
	food_menu.open_food_menu(self)
	
	current_food_menu = food_menu

# ================== FEED ==================
func feed() -> void:
	if is_fed:
		print("🐔 Gà này đã được cho ăn rồi!")
		return
	
	is_fed = true
	print("🍗 ĐÃ CHO GÀ ĂN! Timer bắt đầu đếm ", time_to_lay_egg, " giây")
	
	if state_machine:
		state_machine.transition_to("eating")
	
	egg_timer.stop()                    # Reset timer cũ
	egg_timer.wait_time = time_to_lay_egg
	egg_timer.start()
	
	print("⏰ EGG TIMER ĐÃ START - Chờ ", time_to_lay_egg, " giây")

# ================== TIMER TIMEOUT ==================
func _on_egg_timer_timeout() -> void:
	print("⏰ EGG TIMER TIMEOUT → Gà đẻ trứng!")
	lay_egg()
	is_fed = false
	if state_machine:
		state_machine.transition_to("idle")

# ================== LAY EGG ==================
func lay_egg() -> void:
	if not egg_scene:
		push_error("❌ Missing egg_scene!")
		return
	var egg = egg_scene.instantiate()
	var spawn_pos = egg_spawn_point.global_position if egg_spawn_point else global_position + Vector2(0, 20)
	egg.global_position = spawn_pos
	get_parent().add_child(egg)
	print("✅ 🥚 GÀ ĐÃ ĐẺ TRỨNG tại ", spawn_pos)

func is_hungry() -> bool:
	return not is_fed

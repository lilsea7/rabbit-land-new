extends NonPlayableCharacter
class_name Cow

# ================== NODE ==================
@onready var milk_timer: Timer = $MilkProductionTimer
@onready var interaction_area: Area2D = $InteractionArea
@onready var milk_spawn_point: Marker2D = $Marker2D          # ← Đổi thành tên node thực tế của bạn nếu khác
@onready var state_machine: NodeStateMachine = $StateMachine

# ================== CONFIG ==================
@export var time_to_produce_milk: float = 60.0

# ================== STATE ==================
var is_fed: bool = false
var player_in_range: bool = false
var current_food_menu = null

# ================== RESOURCE ==================
var milk_scene: PackedScene = preload("res://scenes/object/milk.tscn")
var food_menu_scene: PackedScene = preload("res://scenes/ui/food_menu.tscn")

# ================== READY ==================
func _ready() -> void:
	print("🐄 Cow _ready()")
	milk_timer.one_shot = true
	milk_timer.timeout.connect(_on_milk_timer_timeout)
	
	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)

# ================== PLAYER DETECT ==================
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("👉 Player vào vùng bò")
		player_in_range = true
		body.set_interact_target(self)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		print("👈 Player rời vùng bò")
		player_in_range = false
		body.clear_interact_target(self)
		
		# Tự động đóng FoodMenu khi rời vùng
		if current_food_menu and is_instance_valid(current_food_menu):
			current_food_menu.close_menu()
			current_food_menu.queue_free()
			current_food_menu = null

# ================== INTERACT - CHỈ MỞ KHI ĐÃ UNLOCK (Level 8) ==================
func interact() -> void:
	if not player_in_range:
		return
	
	# Kiểm tra an toàn LevelManager
	if not LevelManager or not LevelManager.has_method("is_unlocked"):
		print("⚠️ LevelManager chưa sẵn sàng!")
		return
	
	# === KIỂM TRA UNLOCK CHO BÒ (Level 8) ===
	if not LevelManager.is_unlocked("cow"):
		print("❌ Chức năng cho bò ăn chưa được mở khóa! Cần đạt Level 8.")
		return
	
	# Không cho mở nhiều menu cùng lúc
	if current_food_menu and is_instance_valid(current_food_menu):
		print("⚠️ FoodMenu đã tồn tại")
		return
	
	print("🐄 Player bấm E → Mở Food Menu cho Bò")
	
	var food_menu = food_menu_scene.instantiate()
	get_tree().root.add_child(food_menu)
	food_menu.open_food_menu(self)
	
	current_food_menu = food_menu

# ================== FEED ==================
func feed() -> void:
	if is_fed:
		print("🐄 Bò này đã được cho ăn rồi!")
		return
	
	is_fed = true
	print("🌾 ĐÃ CHO BÒ ĂN! Timer bắt đầu đếm ", time_to_produce_milk, " giây để cho sữa")
	
	# Cộng kinh nghiệm
	LevelManager.add_exp(LevelManager.exp_rewards["feed_cow"], "feed_cow")
	
	if state_machine:
		state_machine.transition_to("eating")
	
	milk_timer.stop()
	milk_timer.wait_time = time_to_produce_milk
	milk_timer.start()
	
	print("⏰ MILK TIMER ĐÃ START")

# ================== TIMER & PRODUCE MILK ==================
func _on_milk_timer_timeout() -> void:
	print("⏰ MILK TIMER TIMEOUT → Bò cho sữa!")
	produce_milk()
	is_fed = false
	if state_machine:
		state_machine.transition_to("idle")

func produce_milk() -> void:
	if not milk_scene:
		push_error("❌ Missing milk_scene!")
		return
	
	var milk = milk_scene.instantiate()
	var spawn_pos = milk_spawn_point.global_position if milk_spawn_point else global_position + Vector2(0, 20)
	milk.global_position = spawn_pos
	get_parent().add_child(milk)
	print("✅ 🥛 BÒ ĐÃ CHO 1 SỮA tại ", spawn_pos)

func is_hungry() -> bool:
	return not is_fed

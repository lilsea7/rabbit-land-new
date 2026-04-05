extends Node

signal level_up(new_level: int)
signal exp_changed(current_exp: int, exp_to_next: int)

var current_level: int = 1
var current_exp: int = 0

# Exp cần để lên từng level
var exp_required = {
	1: 50,
	2: 70,
	3: 100,
	4: 200,
	5: 250,
	6: 350,
	7: 400,
	8: 550,
	9: 800,
	10: 1000,
	11: 1200
}

# Exp thưởng cho từng hành động
var exp_rewards = {
	"chop_tree": 5,
	"mine_stone": 5,
	"till_ground": 5,
	"plant_seed": 6,
	"harvest_crop": 7,
	"harvest_egg": 10,
	"feed_chicken": 8,
	"harvest_milk": 15,
	"feed_cow": 8,
}

func _ready() -> void:
	print("LevelManager đã khởi tạo - Level hiện tại: ", current_level)

func add_exp(amount: int, action_name: String = "") -> void:
	if amount <= 0:
		return
	
	current_exp += amount
	print("📈 Nhận ", amount, " exp từ: ", action_name)
	
	exp_changed.emit(current_exp, get_exp_to_next_level())
	
	check_level_up()

func check_level_up() -> void:
	while current_level < exp_required.size() and current_exp >= get_exp_to_next_level():
		var exp_needed = get_exp_to_next_level()
		current_exp -= exp_needed
		current_level += 1
		
		print("🎉 LEVEL UP! Bạn đã lên Level ", current_level)
		level_up.emit(current_level)
		
		# Gọi thông báo Level Up
		var unlock_text = get_unlock_text(current_level)
		if has_node("/root/LevelUpNotification"):
			LevelUpNotification.show_level_up(current_level, unlock_text)

func get_exp_to_next_level() -> int:
	return exp_required.get(current_level, 999999)

func get_progress_percent() -> float:
	var needed = get_exp_to_next_level()
	if needed <= 0:
		return 100.0
	return (float(current_exp) / needed) * 100.0

# ================== HÀM MỚI: LẤY TEXT MÔ TẢ UNLOCK ==================
func get_unlock_text(level: int) -> String:
	match level:
		2:  return "Cuốc đất"
		3:  return "Hạt giống lúa mì, cà chua"
		4:  return "Vật nuôi (Gà)"
		5:  return "Mở Chợ"
		8:  return "Vật nuôi (Bò)"
		11: return "Vùng đất mới"
		_:  return "Khả năng mới"

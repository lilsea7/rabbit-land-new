# level_manager.gd
extends Node

signal level_up(new_level: int)
signal exp_changed(current_exp: int, exp_to_next: int)

# Dữ liệu hiện tại
var current_level: int = 1
var current_exp: int = 0

# Exp cần để lên level (theo bảng của bạn)
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

# Hàm chính: Thêm exp
func add_exp(amount: int, action_name: String = "") -> void:
	if amount <= 0:
		return
	
	current_exp += amount
	print("📈 Nhận ", amount, " exp từ: ", action_name)
	
	exp_changed.emit(current_exp, get_exp_to_next_level())
	
	check_level_up()

# Kiểm tra lên level
func check_level_up() -> void:
	while current_level < exp_required.size() and current_exp >= get_exp_to_next_level():
		var exp_needed = get_exp_to_next_level()
		current_exp -= exp_needed
		current_level += 1
		
		print("🎉 LEVEL UP! Bạn đã lên Level ", current_level)
		level_up.emit(current_level)

# Lấy exp cần để lên level tiếp theo
func get_exp_to_next_level() -> int:
	return exp_required.get(current_level, 999999)

# Lấy phần trăm tiến độ
func get_progress_percent() -> float:
	var needed = get_exp_to_next_level()
	if needed <= 0:
		return 100.0
	return (float(current_exp) / needed) * 100.0

# Kiểm tra hành động có được mở khóa chưa
func is_unlocked(action: String) -> bool:
	match action:
		"till_ground":
			return current_level >= 2
		"plant_seed":
			return current_level >= 3
		"chicken":
			return current_level >= 4
		"shop":
			return current_level >= 5
		"cow":
			return current_level >= 8
		_:
			return true

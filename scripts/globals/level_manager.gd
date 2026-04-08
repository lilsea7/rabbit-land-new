extends Node

signal level_up(new_level: int)
signal exp_changed(current_exp: int, exp_to_next: int)
signal feature_unlocked(feature_name: String)

var current_level: int = 1
var current_exp: int = 0

var exp_required = {
	1: 5, 2: 5, 3: 5, 4: 13, 5: 14,
	6: 15, 7: 16, 8: 17, 9: 18, 10: 19
}

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

var unlock_features = {
	3: ["plant_wheat", "plant_tomato", "plant_carrot"],
	4: ["chicken"],
	5: ["shop_market"],        # Level 5 mở Market
	6: ["plant_corn", "plant_rose", "plant_broccoli"],
	8: ["cow"],
	10: ["new_areas"]
}

# Biến đánh dấu đã cấp hạt giống ban đầu chưa (tránh cộng nhiều lần)
var has_given_starter_seeds: bool = false

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
		
		# Reset exp về 0 cho level mới
		current_exp = 0
		
		var has_unlock = unlock_features_for_level(current_level)
		
		var notification = get_node_or_null("/root/LevelUpNotification")
		if notification and notification.has_method("show_level_up"):
			if has_unlock:
				var unlock_text = get_unlock_text(current_level)
				notification.show_level_up(current_level, unlock_text)
			else:
				notification.show_level_up(current_level, "Bạn đã lên level!")
		
		exp_changed.emit(current_exp, get_exp_to_next_level())

# ================== MỞ KHÓA TÍNH NĂNG + CẤP HẠT GIỐNG ==================
func unlock_features_for_level(level: int) -> bool:
	if not unlock_features.has(level):
		return false
	
	var has_new_unlock = false
	
	for feature in unlock_features[level]:
		print("🔓 Đã mở khóa: ", feature)
		feature_unlocked.emit(feature)
		has_new_unlock = true
		
		match feature:
			"plant_wheat", "plant_tomato", "plant_carrot":
				ToolManager.unlock_tool(DataTypes.Tools.PlantWheat)
				ToolManager.unlock_tool(DataTypes.Tools.PlantTomato)
				ToolManager.unlock_tool(DataTypes.Tools.PlantCarrot)
				ToolManager.unlock_tool(DataTypes.Tools.Plants)
			
			"plant_corn", "plant_rose", "plant_broccoli":
				ToolManager.unlock_tool(DataTypes.Tools.PlantCorn)
				ToolManager.unlock_tool(DataTypes.Tools.PlantRose)
				ToolManager.unlock_tool(DataTypes.Tools.PlantBroccoli)
				ToolManager.unlock_tool(DataTypes.Tools.Plants)
			
			"chicken":
				ToolManager.unlock_tool(DataTypes.Tools.Plants)
			
			"cow":
				ToolManager.unlock_tool(DataTypes.Tools.Plants)
			
			"shop_market":   # Level 5 - Mở Market
				print("🛒 Market đã được mở khóa tại Level 5!")

	# === CẤP 5 HẠT GIỐNG BAN ĐẦU - CHỈ THỰC HIỆN 1 LẦN KHI LÊN LEVEL 3 ===
	if level == 3 and not has_given_starter_seeds:
		InventoryManager.add_collectable("wheat_seed", 5)
		InventoryManager.add_collectable("tomato_seed", 5)
		InventoryManager.add_collectable("carrot_seed", 5)
		has_given_starter_seeds = true
		print("🌱 Đã cấp 5 hạt giống ban đầu: Lúa mì, Cà chua, Cà rốt")

	return has_new_unlock

# ================== KIỂM TRA ĐÃ UNLOCK ==================
func is_unlocked(feature: String) -> bool:
	for lvl in unlock_features.keys():
		if lvl <= current_level and feature in unlock_features[lvl]:
			return true
	return false

func get_exp_to_next_level() -> int:
	return exp_required.get(current_level, 999999)

func get_progress_percent() -> float:
	var needed = get_exp_to_next_level()
	if needed <= 0:
		return 100.0
	return (float(current_exp) / needed) * 100.0

func get_unlock_text(level: int) -> String:
	match level:
		3: return "Hạt giống lúa mì, cà chua, cà rốt"
		4: return "Vật nuôi (Gà)"
		5: return "Mở chợ mua bán hàng hóa"
		6: return "Hạt giống ngô, hoa hồng, bông cải xanh"
		8: return "Vật nuôi (Bò)"
		10: return "Vùng đất mới"
		_: return "Khả năng mới"

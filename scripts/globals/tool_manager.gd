extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var current_seed_type: String = "" # Lưu loại hạt giống đang chọn

signal tool_selected(tool: DataTypes.Tools)
signal enable_tool(tool: DataTypes.Tools)

# ================== QUẢN LÝ TOOL ĐÃ MỞ KHÓA ==================
var unlocked_tools = {
	DataTypes.Tools.AxeWood: false,
	DataTypes.Tools.TillGround: false,
	DataTypes.Tools.WaterCrops: false,
	DataTypes.Tools.PlantWheat: false,
	DataTypes.Tools.PlantTomato: false,
	DataTypes.Tools.PlantCarrot: false,
	DataTypes.Tools.PlantCorn: false,
	DataTypes.Tools.PlantRose: false,
	DataTypes.Tools.PlantBroccoli: false,
	DataTypes.Tools.PlantPumkin: false,
	DataTypes.Tools.PlantAubergine: false,
	DataTypes.Tools.Plants: true   # Luôn mở vì là nút mở UI
}

func _ready() -> void:
	pass

# ================== CHỌN TOOL ==================
func selecet_tool(tool: DataTypes.Tools) -> void:
	# Kiểm tra tool đã được mở khóa chưa
	if not unlocked_tools.has(tool) or not unlocked_tools[tool]:
		print("❌ Tool này chưa được mở khóa!")
		return

	# Xử lý set loại hạt giống tương ứng
	match tool:
		DataTypes.Tools.PlantWheat:
			current_seed_type = "Wheat"
			print("Chế độ trồng: Wheat")
		DataTypes.Tools.PlantTomato:
			current_seed_type = "Tomato"
			print("Chế độ trồng: Tomato")
		DataTypes.Tools.PlantCarrot:
			current_seed_type = "Carrot"
			print("Chế độ trồng: Carrot")
		DataTypes.Tools.PlantCorn:
			current_seed_type = "Corn"
			print("Chế độ trồng: Corn")
		DataTypes.Tools.PlantRose:
			current_seed_type = "Rose"
			print("Chế độ trồng: Rose")
		DataTypes.Tools.PlantBroccoli:
			current_seed_type = "Broccoli"
			print("Chế độ trồng: Broccoli")
		DataTypes.Tools.PlantPumkin:
			current_seed_type = "Pumkin"
			print("Chế độ trồng: Pumkin")
		DataTypes.Tools.PlantAubergine:
			current_seed_type = "Aubergine"
			print("Chế độ trồng: Aubergine")
		DataTypes.Tools.Plants:
			current_seed_type = ""
			print("Mở giao diện chọn hạt giống")
		_:
			current_seed_type = ""
			print("Bỏ chế độ trồng")

	selected_tool = tool
	tool_selected.emit(tool)

# ================== MỞ KHÓA TOOL ==================
func unlock_tool(tool: DataTypes.Tools) -> void:
	if unlocked_tools.has(tool):
		if not unlocked_tools[tool]:   # Chỉ in khi mới mở khóa
			unlocked_tools[tool] = true
			enable_tool.emit(tool)
			print("🔓 Đã mở khóa tool: ", DataTypes.Tools.keys()[tool])
	else:
		print("⚠️ Tool không tồn tại trong unlocked_tools: ", tool)

# ================== HÀM CŨ ==================
func enable_tool_button(tool: DataTypes.Tools) -> void:
	enable_tool.emit(tool)

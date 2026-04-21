# tool_manager.gd
extends Node
var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var current_seed_type: String = ""
signal tool_selected(tool: DataTypes.Tools)
signal enable_tool(tool: DataTypes.Tools)

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
	DataTypes.Tools.Plants: true
}

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_tool"):
		selecet_tool(DataTypes.Tools.None)
		get_viewport().set_input_as_handled()

# ================== CHỌN TOOL ==================
func selecet_tool(tool: DataTypes.Tools) -> void:
	# Cho phép bỏ tool mà không cần check unlock
	if tool == DataTypes.Tools.None:
		selected_tool = DataTypes.Tools.None
		current_seed_type = ""
		tool_selected.emit(DataTypes.Tools.None)
		print("🔄 Đã bỏ chọn tool")
		return

	# Kiểm tra tool đã được mở khóa chưa
	if not unlocked_tools.has(tool) or not unlocked_tools[tool]:
		print("❌ Tool này chưa được mở khóa!")
		return

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
		if not unlocked_tools[tool]:
			unlocked_tools[tool] = true
			enable_tool.emit(tool)
			print("🔓 Đã mở khóa tool: ", DataTypes.Tools.keys()[tool])
	else:
		print("⚠️ Tool không tồn tại trong unlocked_tools: ", tool)

func enable_tool_button(tool: DataTypes.Tools) -> void:
	enable_tool.emit(tool)

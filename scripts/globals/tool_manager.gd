#extends Node
#
#var selected_tool: DataTypes.Tools = DataTypes.Tools.None
#
#signal tool_selected(tool: DataTypes.Tools)
#signal enable_tool(tool: DataTypes.Tools)
#
#func selecet_tool(tool: DataTypes.Tools) -> void:
	#tool_selected.emit(tool)
	#selected_tool = tool
#
#func enable_tool_button(tool: DataTypes.Tools) -> void:
	#enable_tool.emit(tool)

extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var current_seed_type: String = ""   # Lưu loại hạt giống đang chọn ("Wheat", "Carrot", ...)

signal tool_selected(tool: DataTypes.Tools)
signal enable_tool(tool: DataTypes.Tools)

func selecet_tool(tool: DataTypes.Tools) -> void:
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
		DataTypes.Tools.Plants:
			current_seed_type = ""  # Không set seed khi chỉ mở UI
			print("Mở giao diện chọn hạt giống")
		_:
			current_seed_type = ""  # Reset khi chọn tool khác (Axe, Till, Water, None...)
			print("Bỏ chế độ trồng")

	selected_tool = tool
	tool_selected.emit(tool)

func enable_tool_button(tool: DataTypes.Tools) -> void:
	enable_tool.emit(tool)

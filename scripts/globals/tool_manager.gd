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
signal tool_selected(tool: DataTypes.Tools)
signal enable_tool(tool: DataTypes.Tools)

# Biến mới: lưu loại hạt giống đang chọn để player gieo
var current_seed_type: String = ""  # "Wheat", "Tomato", ...

func selecet_tool(tool: DataTypes.Tools) -> void:
	# Xử lý chế độ trồng cây
	match tool:
		DataTypes.Tools.PlantWheat:
			current_seed_type = "Wheat"
			print("Chế độ trồng: Wheat")
		DataTypes.Tools.PlantTomato:
			current_seed_type = "Tomato"
			print("Chế độ trồng: Tomato")
		DataTypes.Tools.None, DataTypes.Tools.AxeWood, DataTypes.Tools.TillGround, DataTypes.Tools.WaterCrops:
			current_seed_type = ""  # reset khi không trồng
			print("Bỏ chế độ trồng")
		DataTypes.Tools.Plants:
			print("Mở giao diện chọn hạt giống")
			# Nếu bạn muốn tự động mở PlantsUI ở đây, có thể gọi hàm mở UI
			# Nhưng vì bạn mở UI từ tool panel rồi, nên không cần thêm ở đây
	
	selected_tool = tool
	tool_selected.emit(tool)

func enable_tool_button(tool: DataTypes.Tools) -> void:
	enable_tool.emit(tool)

#extends PanelContainer
#
#@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
#@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
#@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
#@onready var tool_plants: Button = $MarginContainer/HBoxContainer/ToolPlants
#@onready var tool_iventory: Button = $MarginContainer/HBoxContainer/ToolIventory
#
#
#func _ready() -> void:
	#ToolManager.enable_tool.connect(on_enable_tool_button)
	#tool_tilling.disabled = true
	#tool_tilling.focus_mode = Control.FOCUS_NONE
	#
	#tool_watering_can.disabled = true
	#tool_watering_can.focus_mode = Control.FOCUS_NONE
	#
#
#
#func _on_tool_axe_pressed() -> void:
	#ToolManager.selecet_tool(DataTypes.Tools.AxeWood)
#
#
#func _on_tool_tilling_pressed() -> void:
	#ToolManager.selecet_tool(DataTypes.Tools.TillGround)
#
#
#func _on_tool_watering_can_pressed() -> void:
	#ToolManager.selecet_tool(DataTypes.Tools.WaterCrops)
#
#
#func _on_tool_wheat_pressed() -> void:
	#ToolManager.selecet_tool(DataTypes.Tools.PlantWheat)
#
#
#func _on_tool_tomato_pressed() -> void:
	#ToolManager.selecet_tool(DataTypes.Tools.PlantTomato)
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("release_tool"):
		#ToolManager.selecet_tool(DataTypes.Tools.None)
		#tool_axe.release_focus()
		#tool_tilling.release_focus()
		#tool_watering_can.release_focus()
#
		#
#func on_enable_tool_button(tool: DataTypes.Tools) -> void:
	#if tool == DataTypes.Tools.TillGround:
		#tool_tilling.disabled = false
		#tool_tilling.focus_mode = Control.FOCUS_ALL
#
	#elif tool == DataTypes.Tools.WaterCrops:
		#tool_watering_can.disabled = false
		#tool_watering_can.focus_mode = Control.FOCUS_ALL
		#
#extends PanelContainer
#
#@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
#@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
#@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
#@onready var tool_plants: Button = $MarginContainer/HBoxContainer/ToolPlants
#@onready var tool_iventory: Button = $MarginContainer/HBoxContainer/ToolIventory
#
#
#@onready var plants_ui: Control = $"../../PlantsUI"
#
#
#func _ready() -> void:
	#ToolManager.enable_tool.connect(on_enable_tool_button)
	#
	#tool_tilling.disabled = true
	#tool_tilling.focus_mode = Control.FOCUS_NONE
	#
	#tool_watering_can.disabled = true
	#tool_watering_can.focus_mode = Control.FOCUS_NONE
	#
	## Ẩn PlantsUI ban đầu
	#if plants_ui:
		#plants_ui.visible = false
	#
	## Kết nối nút Plants
	#tool_plants.pressed.connect(_on_tool_plants_pressed)
#
#func _on_tool_axe_pressed() -> void:
	#ToolManager.selecet_tool(DataTypes.Tools.AxeWood)
	#_hide_plants_ui()
#
#func _on_tool_tilling_pressed() -> void:
	#ToolManager.selecet_tool(DataTypes.Tools.TillGround)
	#_hide_plants_ui()
#
#func _on_tool_watering_can_pressed() -> void:
	#ToolManager.selecet_tool(DataTypes.Tools.WaterCrops)
	#_hide_plants_ui()
#
#func _on_tool_plants_pressed() -> void:
	#if ToolManager.selected_tool == DataTypes.Tools.Plants:
		## Click lại → bỏ chọn và ẩn UI
		#ToolManager.selecet_tool(DataTypes.Tools.None)
		#_hide_plants_ui()
	#else:
		## Chọn tool Plants → hiện UI
		#ToolManager.selecet_tool(DataTypes.Tools.Plants)
		#if plants_ui:
			#plants_ui.visible = true
			#print("Đã mở Plants UI")
#
#func _on_tool_iventory_pressed() -> void:
	## Logic cho inventory nếu có
	#_hide_plants_ui()
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("release_tool"):
		#ToolManager.selecet_tool(DataTypes.Tools.None)
		#tool_axe.release_focus()
		#tool_tilling.release_focus()
		#tool_watering_can.release_focus()
		#_hide_plants_ui()  # ẩn PlantsUI khi release tool
#
#func on_enable_tool_button(tool: DataTypes.Tools) -> void:
	#if tool == DataTypes.Tools.TillGround:
		#tool_tilling.disabled = false
		#tool_tilling.focus_mode = Control.FOCUS_ALL
	#elif tool == DataTypes.Tools.WaterCrops:
		#tool_watering_can.disabled = false
		#tool_watering_can.focus_mode = Control.FOCUS_ALL
#
## Hàm ẩn PlantsUI (dùng chung)
#func _hide_plants_ui() -> void:
	#if plants_ui:
		#plants_ui.visible = false
		#print("Đã ẩn Plants UI")

extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var tool_plants: Button = $MarginContainer/HBoxContainer/ToolPlants
@onready var tool_iventory: Button = $MarginContainer/HBoxContainer/ToolIventory
@onready var tool_shop: Button = $MarginContainer/HBoxContainer/ToolShop   # ← Nút Shop

# Tham chiếu đến các UI
@onready var plants_ui: Control = $"../../PlantsUI"
@onready var inventory_ui: Control = $"../../InventoryUI"
@onready var shop_ui: Control = $"../../ShopUI"   # ← Thêm dòng này

func _ready() -> void:
	ToolManager.enable_tool.connect(on_enable_tool_button)
	
	tool_tilling.disabled = true
	tool_tilling.focus_mode = Control.FOCUS_NONE
	
	tool_watering_can.disabled = true
	tool_watering_can.focus_mode = Control.FOCUS_NONE
	
	# Ẩn tất cả UI ban đầu
	if plants_ui:
		plants_ui.visible = false
	if inventory_ui:
		inventory_ui.visible = false
	if shop_ui:
		shop_ui.visible = false
	
	# Kết nối các nút
	tool_plants.pressed.connect(_on_tool_plants_pressed)
	tool_iventory.pressed.connect(_on_tool_iventory_pressed)
	tool_shop.pressed.connect(_on_tool_shop_pressed)   # ← Kết nối nút Shop

func _on_tool_axe_pressed() -> void:
	ToolManager.selecet_tool(DataTypes.Tools.AxeWood)
	_hide_all_ui()

func _on_tool_tilling_pressed() -> void:
	ToolManager.selecet_tool(DataTypes.Tools.TillGround)
	_hide_all_ui()

func _on_tool_watering_can_pressed() -> void:
	ToolManager.selecet_tool(DataTypes.Tools.WaterCrops)
	_hide_all_ui()

func _on_tool_plants_pressed() -> void:
	if ToolManager.selected_tool == DataTypes.Tools.Plants:
		ToolManager.selecet_tool(DataTypes.Tools.None)
		_hide_all_ui()
	else:
		ToolManager.selecet_tool(DataTypes.Tools.Plants)
		if plants_ui:
			plants_ui.visible = true
			print("Đã mở Plants UI")

func _on_tool_iventory_pressed() -> void:
	if inventory_ui:
		if inventory_ui.visible:
			inventory_ui.visible = false
			print("Đã đóng Inventory UI")
		else:
			inventory_ui.visible = true
			inventory_ui.open_inventory()
			print("Đã mở Inventory UI")
	else:
		push_error("Không tìm thấy InventoryUI!")

# === LOGIC MỚI: Mở Shop UI ===
func _on_tool_shop_pressed() -> void:
	if shop_ui:
		if shop_ui.visible:
			shop_ui.visible = false
			print("Đã đóng Shop UI")
		else:
			shop_ui.visible = true
			shop_ui.open_shop()          # Gọi hàm mở và cập nhật Shop
			print("Đã mở Shop UI")
	else:
		push_error("Không tìm thấy ShopUI!")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_tool"):
		ToolManager.selecet_tool(DataTypes.Tools.None)
		tool_axe.release_focus()
		tool_tilling.release_focus()
		tool_watering_can.release_focus()
		_hide_all_ui()

func on_enable_tool_button(tool: DataTypes.Tools) -> void:
	if tool == DataTypes.Tools.TillGround:
		tool_tilling.disabled = false
		tool_tilling.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.WaterCrops:
		tool_watering_can.disabled = false
		tool_watering_can.focus_mode = Control.FOCUS_ALL

# Hàm ẩn tất cả UI (dùng chung)
func _hide_all_ui() -> void:
	if plants_ui:
		plants_ui.visible = false
	if inventory_ui:
		inventory_ui.visible = false
	if shop_ui:
		shop_ui.visible = false
	print("Đã ẩn tất cả UI")

#extends Control
#
#@export var visible_on_start: bool = false
#
#@onready var close_plant_ui: Button = $NinePatchRect/NinePatchRect/ClosePlantUI
#
#func _ready() -> void:
	#visible = visible_on_start
	#
	#if close_plant_ui:
		#close_plant_ui.pressed.connect(_on_close_plant_ui_pressed)
		#print("Đã kết nối nút ClosePlantUI thành công")
	#else:
		#push_error("Không tìm thấy nút ClosePlantUI! Kiểm tra đường dẫn: $NinePatchRect/NinePatchRect/ClosePlantUI")
		## Bạn có thể thêm fallback: ẩn UI luôn nếu nút Close không tồn tại
		#visible = false
#
#func show_ui():
	#visible = true
	#print("PlantsUI đã hiển thị")
#
#func hide_ui():
	#visible = false
	#print("PlantsUI đã ẩn")
	## Bỏ chọn tool Plants để đồng bộ với ToolManager
	#if ToolManager:
		#ToolManager.selecet_tool(DataTypes.Tools.None)  # sửa typo nếu cần
	#else:
		#push_warning("ToolManager không tồn tại hoặc chưa sẵn sàng")
#
#func _on_close_plant_ui_pressed() -> void:
	#hide_ui()
	#print("Nút Close được nhấn → ẩn PlantsUI")

#extends Control
#
#@export var visible_on_start: bool = false
#
#@onready var close_plant_ui: Button = $NinePatchRect/NinePatchRect/ClosePlantUI
#
#func _ready() -> void:
	#visible = visible_on_start
	#
	#if close_plant_ui:
		#close_plant_ui.pressed.connect(_on_close_plant_ui_pressed)
		#print("Đã kết nối nút ClosePlantUI thành công")
	#else:
		#push_error("Không tìm thấy nút ClosePlantUI! Kiểm tra đường dẫn: $NinePatchRect/NinePatchRect/ClosePlantUI")
	#
	## Tự động kết nối tất cả slot
	#var grid = $NinePatchRect/GridContainer  # sửa nếu đường dẫn khác
	#for child in grid.get_children():
		#if child is Button:
			#child.pressed.connect(_on_seed_slot_pressed.bind(child.name))
			#print("Đã kết nối slot: ", child.name)
#
#func _on_seed_slot_pressed(slot_name: String) -> void:
	#var action_name = "Plant" + slot_name.replace("Slot", "")
	#
	#if DataTypes.Tools.has(action_name):
		#ToolManager.selecet_tool(DataTypes.Tools[action_name])
		#print("Đã chọn hành động: ", action_name)
		#
		#hide_ui()  # Ẩn UI nhưng KHÔNG reset tool
	#else:
		#push_warning("Không tìm thấy hành động trồng cho slot: " + slot_name)
#
#func show_ui():
	#visible = true
	#print("PlantsUI đã hiển thị")
#
#func hide_ui():
	#visible = false
	#print("PlantsUI đã ẩn")
	## KHÔNG reset tool ở đây nữa
#
#func _on_close_plant_ui_pressed() -> void:
	#hide_ui()
	#ToolManager.selecet_tool(DataTypes.Tools.None)  # Chỉ reset khi bấm Close

extends Control

@export var visible_on_start: bool = false

@onready var close_plant_ui: Button = $NinePatchRect/NinePatchRect/ClosePlantUI

# Dictionary lưu số lượng hạt giống (sync với Inventory sau này)
var seed_inventory = {
	"Wheat": 10,
	"Tomato": 8,
	"Carrot": 5,
	"Corn": 12,
	"Rose": 3,
	"Sunflower": 7
}

# Dictionary lưu Label số lượng theo slot name
var quantity_labels = {}

func _ready() -> void:
	visible = visible_on_start
	
	if close_plant_ui:
		close_plant_ui.pressed.connect(_on_close_plant_ui_pressed)
		print("Đã kết nối nút ClosePlantUI thành công")
	else:
		push_error("Không tìm thấy nút ClosePlantUI!")
	
	# Tự động kết nối slot và lấy Label số lượng
	var grid = $NinePatchRect/GridContainer  # sửa nếu đường dẫn khác
	for child in grid.get_children():
		if child is Button:
			var slot_name = child.name  # Slot_Wheat
			child.pressed.connect(_on_seed_slot_pressed.bind(slot_name))
			print("Đã kết nối slot: ", slot_name)
			
			# Tìm Label số lượng trong slot
			var label = child.get_node_or_null("NinePatchRect/QuantityLabel")
			if label:
				quantity_labels[slot_name] = label
				update_quantity_label(slot_name)
			else:
				push_warning("Slot ", slot_name, " không có QuantityLabel!")

func update_quantity_label(slot_name: String) -> void:
	var label = quantity_labels.get(slot_name)
	if label:
		var seed_type = slot_name.replace("Slot", "")
		var quantity = seed_inventory.get(seed_type, 0)
		label.text = str(quantity)
		
		# Gán disabled cho Button cha (SlotWheat, SlotTomato...)
		var slot_button = label.get_parent().get_parent()  # QuantityLabel → NinePatchRect → SlotWheat
		if slot_button is Button:
			if quantity <= 0:
				label.modulate = Color(1, 0, 0, 1)  # đỏ
				slot_button.disabled = true
			else:
				label.modulate = Color(1, 1, 1, 1)  # trắng
				slot_button.disabled = false
		else:
			push_warning("Không tìm thấy Button cha của slot ", slot_name)

func _on_seed_slot_pressed(slot_name: String) -> void:
	var seed_type = slot_name.replace("Slot", "")
	
	var quantity = seed_inventory.get(seed_type, 0)
	if quantity > 0:
		# Chọn hành động trồng
		var action_name = "Plant" + seed_type
		if DataTypes.Tools.has(action_name):
			ToolManager.selecet_tool(DataTypes.Tools[action_name])
			print("Đã chọn hành động: ", action_name)
			
			# Giảm số lượng (tạm thời - sau này sync với Inventory)
			seed_inventory[seed_type] -= 1
			update_quantity_label(slot_name)
			
			hide_ui()
		else:
			push_warning("Không có hành động trồng cho ", seed_type)
	else:
		print("Hết ", seed_type)

func show_ui():
	visible = true
	print("PlantsUI đã hiển thị")
	for slot_name in quantity_labels.keys():
		update_quantity_label(slot_name)

func hide_ui():
	visible = false
	print("PlantsUI đã ẩn")
	# KHÔNG reset tool ở đây nữa (chỉ reset khi close hoặc release)

func _on_close_plant_ui_pressed() -> void:
	hide_ui()
	ToolManager.selecet_tool(DataTypes.Tools.None)

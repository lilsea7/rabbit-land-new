#extends Control
#
#@export var visible_on_start: bool = false
#
#@onready var close_plant_ui: Button = $NinePatchRect/NinePatchRect/ClosePlantUI
#
## Danh sách hạt giống và số lượng ban đầu
#var seed_inventory = {
	#"Carrot":    6,
	#"Corn":      12,
	#"Pumkin": 10,
	#"Aubergine": 10,
	#"Rose":      4,
	#"Broccoli": 5,
	#"Wheat": 10,
	#"Tomato": 10
#}
#
#var quantity_labels = {}
#
#func _ready() -> void:
	#visible = visible_on_start
	#
	#if close_plant_ui:
		#close_plant_ui.pressed.connect(_on_close_plant_ui_pressed)
		#print("Đã kết nối nút ClosePlantUI thành công")
	#
	## Tự động kết nối tất cả slot và lấy QuantityLabel
	#var grid = $NinePatchRect/GridContainer
	#for child in grid.get_children():
		#if child is Button:
			#var slot_name = child.name
			#child.pressed.connect(_on_seed_slot_pressed.bind(slot_name))
			#print("Đã kết nối slot: ", slot_name)
			#
			## Tìm QuantityLabel (theo cấu trúc hiện tại của bạn)
			#var label = child.get_node_or_null("NinePatchRect/QuantityLabel")
			#if label:
				#quantity_labels[slot_name] = label
				#update_quantity_label(slot_name)
			#else:
				#push_warning("Slot ", slot_name, " thiếu QuantityLabel!")
#
#func update_quantity_label(slot_name: String) -> void:
	#var label = quantity_labels.get(slot_name)
	#if not label:
		#return
	#
	#var seed_type = slot_name.replace("Slot", "")
	#var quantity = seed_inventory.get(seed_type, 0)
	#label.text = str(quantity)
	#
	## Tìm Button cha để disable khi hết hạt
	#var slot_button = label.get_parent().get_parent()  # QuantityLabel → NinePatchRect → SlotButton
	#if slot_button is Button:
		#if quantity <= 0:
			#label.modulate = Color(1, 0, 0, 1)      # đỏ
			#slot_button.disabled = true
		#else:
			#label.modulate = Color(1, 1, 1, 1)      # trắng
			#slot_button.disabled = false
#
#func _on_seed_slot_pressed(slot_name: String) -> void:
	#var seed_type = slot_name.replace("Slot", "")
	#
	#if seed_inventory.get(seed_type, 0) > 0:
		#var action_name = "Plant" + seed_type
		#
		#if DataTypes.Tools.has(action_name):
			#ToolManager.selecet_tool(DataTypes.Tools[action_name])
			#print("Đã chọn trồng: ", action_name)
			#hide_ui()                    # Ẩn UI sau khi chọn
		#else:
			#push_warning("Không tìm thấy hành động Plant" + seed_type)
	#else:
		#print("Hết hạt giống ", seed_type)
#
#func show_ui():
	#visible = true
	#print("PlantsUI đã hiển thị")
	## Cập nhật lại số lượng khi mở UI
	#for slot_name in quantity_labels.keys():
		#update_quantity_label(slot_name)
#
#func hide_ui():
	#visible = false
	#print("PlantsUI đã ẩn")
#
#func _on_close_plant_ui_pressed() -> void:
	#hide_ui()
	#ToolManager.selecet_tool(DataTypes.Tools.None)
extends Control

@export var visible_on_start: bool = false

@onready var close_plant_ui: Button = $NinePatchRect/NinePatchRect/ClosePlantUI

# Dictionary ánh xạ tên slot → tên hạt giống trong Inventory
var slot_to_seed = {
	"SlotWheat": "wheat_seed",
	"SlotTomato": "tomato_seed",
	"SlotCarrot": "carrot_seed",
	"SlotCorn": "corn_seed",
	"SlotRose": "rose_seed",
	"SlotBroccoli": "broccoli_seed",
	"SlotPumkin": "pumkin_seed",
	"SlotAubergine": "aubergine_seed"
}

var quantity_labels = {}

func _ready() -> void:
	visible = visible_on_start
	
	if close_plant_ui:
		close_plant_ui.pressed.connect(_on_close_plant_ui_pressed)
		print("Đã kết nối nút ClosePlantUI thành công")
	
	# Kết nối tất cả slot
	var grid = $NinePatchRect/GridContainer
	for child in grid.get_children():
		if child is Button:
			var slot_name = child.name
			child.pressed.connect(_on_seed_slot_pressed.bind(slot_name))
			print("Đã kết nối slot: ", slot_name)
			
			# Tìm QuantityLabel
			var label = child.get_node_or_null("NinePatchRect/QuantityLabel")
			if label:
				quantity_labels[slot_name] = label
			else:
				push_warning("Slot " + slot_name + " thiếu QuantityLabel!")
	
	# Kết nối với InventoryManager và ShopManager để tự động cập nhật
	if InventoryManager:
		InventoryManager.inventory_changed.connect(update_all_quantities)
	
	if ShopManager:
		ShopManager.money_changed.connect(update_all_quantities)
	
	update_all_quantities()

# Cập nhật tất cả số lượng hạt giống
func update_all_quantities(_new_amount = null) -> void:
	for slot_name in quantity_labels.keys():
		update_quantity_label(slot_name)

func update_quantity_label(slot_name: String) -> void:
	var label = quantity_labels.get(slot_name)
	if not label:
		return
	
	var seed_item_name = slot_to_seed.get(slot_name, "")
	if seed_item_name == "":
		return
	
	var quantity = InventoryManager.get_quantity(seed_item_name)
	label.text = str(quantity)
	
	# Tìm Button cha để disable khi hết hạt
	var slot_button = label.get_parent().get_parent()  # QuantityLabel → NinePatchRect → Button
	if slot_button is Button:
		if quantity <= 0:
			label.modulate = Color(1, 0, 0, 1)   # đỏ
			slot_button.disabled = true
		else:
			label.modulate = Color(1, 1, 1, 1)   # trắng
			slot_button.disabled = false

func _on_seed_slot_pressed(slot_name: String) -> void:
	var seed_item_name = slot_to_seed.get(slot_name, "")
	if seed_item_name == "":
		return
	
	var quantity = InventoryManager.get_quantity(seed_item_name)
	if quantity > 0:
		# Chuyển sang chế độ trồng
		var action_name = "Plant" + seed_item_name.replace("_seed", "").capitalize()
		if DataTypes.Tools.has(action_name):
			ToolManager.selecet_tool(DataTypes.Tools[action_name])   # Sửa lỗi chính tả
			print("Đã chọn trồng: ", action_name)
			hide_ui()
		else:
			push_warning("Không tìm thấy hành động: " + action_name)
	else:
		print("Hết hạt giống ", seed_item_name)

func show_ui():
	visible = true
	update_all_quantities()        # Cập nhật lại số lượng khi mở
	print("PlantsUI đã hiển thị")

func hide_ui():
	visible = false
	print("PlantsUI đã ẩn")

func _on_close_plant_ui_pressed() -> void:
	hide_ui()
	ToolManager.selecet_tool(DataTypes.Tools.None)

#extends Control
#
#@export var description: NinePatchRect
#
#@onready var close_button: Button = $NinePatchRect/CloseButton
#
#
## Giả sử bạn có GridContainer chứa các Slot đã đặt sẵn
#@onready var grid_container: GridContainer = $NinePatchRect/GridContainer
#
#
#func _ready() -> void:
	#if close_button:
		#close_button.pressed.connect(_on_close_button_pressed)
		#print("✅ Đã kết nối nút Close cho Inventory UI")
	#
	#if InventoryManager:
		#InventoryManager.inventory_changed.connect(_on_inventory_changed)
	#
	#_on_inventory_changed()  # Cập nhật lần đầu
#
#func _on_inventory_changed() -> void:
	#if grid_container == null:
		#return
	#
	#var inventory = InventoryManager.inventory
	#
	## Cập nhật số lượng cho từng slot đã có sẵn
	#for slot in grid_container.get_children():
		#if slot is PanelContainer and slot.has_method("update_quantity_from_name"):
			#var slot_name = slot.name  # Ví dụ: SlotWheat, SlotTomato...
			#var item_name = slot_name.replace("Slot", "")
			#var quantity = inventory.get(item_name, 0)
			#
			## Gọi hàm update trong slot
			#slot.update_quantity(quantity)
#
## Đóng UI
#func _on_close_button_pressed() -> void:
	#visible = false
	#print("Inventory UI đã đóng")
#
#func open_inventory() -> void:
	#visible = true
	#_on_inventory_changed()
	#print("Inventory UI đã mở")

extends Control

@export var description: NinePatchRect

@onready var close_button: Button = $NinePatchRect/CloseButton
@onready var grid_container: GridContainer = $NinePatchRect/GridContainer

func _ready() -> void:
	if close_button:
		close_button.pressed.connect(_on_close_button_pressed)
		print("✅ Đã kết nối nút Close cho Inventory UI")
	
	if InventoryManager and not InventoryManager.inventory_changed.is_connected(_on_inventory_changed):
		InventoryManager.inventory_changed.connect(_on_inventory_changed)
	
	_on_inventory_changed()

func _on_inventory_changed() -> void:
	if grid_container == null:
		return
	
	var inventory: Dictionary = InventoryManager.inventory
	
	print("🔄 Cập nhật Inventory UI. Số loại vật phẩm: ", inventory.size())
	
	for slot in grid_container.get_children():
		if slot is PanelContainer and slot.has_method("update_quantity"):
			var item_name = ""
			
			if slot.item != null:
				item_name = slot.item.title.to_lower().strip_edges()   # ← Dùng .title
			else:
				print("   Slot ", slot.name, " chưa gán Item Resource!")
				continue
			
			var quantity = inventory.get(item_name, 0)
			
			print("   Slot: ", slot.name, " → Item: '", item_name, "' | Số lượng: ", quantity)
			
			slot.update_quantity(quantity)
	
	print("✅ Hoàn tất cập nhật Inventory UI")

func _on_close_button_pressed() -> void:
	visible = false
	print("Inventory UI đã đóng")

func open_inventory() -> void:
	visible = true
	_on_inventory_changed()
	print("Inventory UI đã mở")

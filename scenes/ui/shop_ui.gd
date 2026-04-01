extends Control

@onready var close_button: Button = $NinePatchRect/CloseButton
@onready var grid_container: GridContainer = $NinePatchRect/GridContainer

func _ready() -> void:
	if close_button:
		close_button.pressed.connect(_on_close_button_pressed)
		print("✅ Đã kết nối nút Close cho Shop UI")
	else:
		push_error("❌ Không tìm thấy CloseButton!")
	
	if grid_container:
		print("✅ GridContainer tìm thấy, có ", grid_container.get_child_count(), " slot ban đầu")
	
	# Kết nối signal từ InventoryManager
	if InventoryManager and not InventoryManager.inventory_changed.is_connected(_on_inventory_changed):
		InventoryManager.inventory_changed.connect(_on_inventory_changed)
		print("✅ Đã kết nối InventoryManager")
	
	# Cập nhật lần đầu
	_on_inventory_changed()

# ================== CẬP NHẬT SHOP UI (giống Inventory UI) ==================
func _on_inventory_changed() -> void:
	if grid_container == null:
		return
	
	var inventory = InventoryManager.inventory
	
	print("🔄 Cập nhật Shop UI. Số loại vật phẩm: ", inventory.size())
	
	for slot in grid_container.get_children():
		if slot is PanelContainer:
			var item_name = ""
			
			# Lấy tên vật phẩm từ Resource Item đã gán sẵn trong Editor (giống Inventory)
			if slot.item != null:
				item_name = slot.item.title.to_lower().strip_edges()   # Dùng .title vì trước đó bạn dùng title
				# Nếu Resource Item của bạn dùng field khác (ví dụ item_name), thay .title thành field đó
			else:
				print("   Slot ", slot.name, " chưa gán Item Resource!")
				continue
			
			var quantity = inventory.get(item_name, 0)
			
			print("   Slot: ", slot.name, " → Item: '", item_name, "' | Số lượng: ", quantity)
			
			# Cập nhật số lượng vào slot
			if slot.has_method("update_quantity"):
				slot.update_quantity(quantity)
			
			# Kết nối click để bán (chỉ kết nối 1 lần)
			if not slot.gui_input.is_connected(_on_slot_clicked):
				slot.gui_input.connect(_on_slot_clicked.bind(item_name))
	
	print("✅ Hoàn tất cập nhật Shop UI\n")

# ================== CLICK VÀO SLOT = BÁN NGAY 1 ĐƠN VỊ ==================
func _on_slot_clicked(event: InputEvent, item_name: String) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("🖱️ Click bán: ", item_name)
		
		# Bán 1 đơn vị
		if ShopManager.sell_item(item_name, 1):
			_on_inventory_changed()                    # Refresh Shop UI
			# Refresh Inventory UI nếu đang mở
			var inv_ui = get_tree().get_first_node_in_group("InventoryUI")
			if inv_ui and inv_ui.has_method("_on_inventory_changed"):
				inv_ui._on_inventory_changed()
		else:
			print("❌ Không đủ ", item_name, " để bán!")

# ================== NÚT ĐÓNG ==================
func _on_close_button_pressed() -> void:
	visible = false
	print("Shop UI đã đóng")

func open_shop() -> void:
	visible = true
	_on_inventory_changed()
	print("Shop UI đã mở")

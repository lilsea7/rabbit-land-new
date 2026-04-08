# shop_ui.gd
extends Control

@onready var inventory_grid: GridContainer = $NinePatchRect/GridContainer
@onready var sell_vbox: VBoxContainer = $NinePatchRect2/ScrollContainer/VBoxContainer
@onready var close_button: Button = $NinePatchRect/CloseButton

func _ready() -> void:
	if close_button:
		close_button.pressed.connect(_on_close_button_pressed)

	if InventoryManager and not InventoryManager.inventory_changed.is_connected(_on_inventory_changed):
		InventoryManager.inventory_changed.connect(_on_inventory_changed)

	_on_inventory_changed()

func open_shop() -> void:
	visible = true
	_on_inventory_changed()

func _on_close_button_pressed() -> void:
	visible = false

# ================== CẬP NHẬT INVENTORY BÊN TRÁI ==================
func _on_inventory_changed() -> void:
	if inventory_grid == null:
		return

	var inventory: Dictionary = InventoryManager.inventory

	# Duyệt slot có sẵn trong scene, giống hệt inventory UI
	for slot in inventory_grid.get_children():
		if slot is PanelContainer and slot.has_method("update_quantity"):
			if slot.item == null:
				continue
			var item_key = slot.item.title.to_lower().strip_edges()
			slot.update_quantity(inventory.get(item_key, 0))

	_update_sell_buttons()

# ================== CẬP NHẬT NÚT SELL BÊN PHẢI ==================
func _update_sell_buttons() -> void:
	var inventory: Dictionary = InventoryManager.inventory

	for item_panel in sell_vbox.get_children():
		if not item_panel is Control:
			continue

		var item_key = item_panel.name.to_lower().strip_edges()

		# Chỉ disable/enable ButtonSell, không đụng vào Label hay Coin
		var sell_btn = item_panel.get_node_or_null("ButtonSell")
		if sell_btn:
			if sell_btn.pressed.is_connected(_on_sell_pressed):
				sell_btn.pressed.disconnect(_on_sell_pressed)
			sell_btn.pressed.connect(_on_sell_pressed.bind(item_key))
			sell_btn.disabled = inventory.get(item_key, 0) <= 0

# ================== LOGIC BÁN VẬT PHẨM ==================
func _on_sell_pressed(item_name: String) -> void:
	var success = ShopManager.sell_item(item_name, 1)
	if success:
		InventoryManager.inventory_changed.emit()
		print("✅ Đã bán 1x ", item_name, " | Tiền: ", ShopManager.player_money)
	else:
		print("❌ Không thể bán ", item_name)

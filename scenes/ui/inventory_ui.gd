extends Control

@export var description: NinePatchRect
@onready var close_button: Button = $NinePatchRect/CloseButton
@onready var grid_container: GridContainer = $NinePatchRect/GridContainer

# Các node trong Description panel
@onready var name_des: Label = $NinePatchRect/Description/Name
@onready var desc_description: RichTextLabel = $NinePatchRect/Description/Description
@onready var icon: TextureRect = $NinePatchRect/Description/Icon


func _ready() -> void:
	if close_button:
		close_button.pressed.connect(_on_close_button_pressed)
		print("✅ Đã kết nối nút Close cho Inventory UI")

	if InventoryManager and not InventoryManager.inventory_changed.is_connected(_on_inventory_changed):
		InventoryManager.inventory_changed.connect(_on_inventory_changed)

	clear_description()
	_on_inventory_changed()

func _on_inventory_changed() -> void:
	if grid_container == null:
		return

	var inventory: Dictionary = InventoryManager.inventory

	for slot in grid_container.get_children():
		if slot is PanelContainer and slot.has_method("update_quantity"):
			if slot.item == null:
				continue
			var item_name = slot.item.title.to_lower().strip_edges()
			var quantity = inventory.get(item_name, 0)
			slot.update_quantity(quantity)

	print("✅ Hoàn tất cập nhật Inventory UI")

# ================== DESCRIPTION ==================
func set_description(item: Item) -> void:
	if item == null:
		clear_description()
		return

	if name_des:
		name_des.text = item.title

	if desc_description:
		desc_description.text = item.description if item.get("description") else ""

	if icon:
		icon.texture = item.icon if item.icon else null

func clear_description() -> void:
	if name_des:
		name_des.text = ""
	if desc_description:
		desc_description.text = ""
	if icon:
		icon.texture = null

func _on_close_button_pressed() -> void:
	visible = false
	clear_description()
	SoundManager.play_button_click()

func open_inventory() -> void:
	visible = true
	_on_inventory_changed()

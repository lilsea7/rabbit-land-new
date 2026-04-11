extends CanvasLayer

@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var corn_food: Button = $NinePatchRect/HBoxContainer/CornFood
@onready var wheat_food: Button = $NinePatchRect/HBoxContainer/WheatFood

@onready var qty_corn: Label = $NinePatchRect/HBoxContainer/CornFood/QuantityCorn
@onready var qty_wheat: Label = $NinePatchRect/HBoxContainer/WheatFood/QuantityWheat

# Biến chung cho cả Gà và Bò
var target_animal = null

func _ready() -> void:
	print("=== FOOD MENU (CanvasLayer) _READY() ===")
	
	if corn_food:
		corn_food.pressed.connect(_on_corn_food_pressed)
		corn_food.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if wheat_food:
		wheat_food.pressed.connect(_on_wheat_food_pressed)
		wheat_food.mouse_filter = Control.MOUSE_FILTER_STOP
	
	hide()

# Hàm mở UI - chấp nhận cả Chicken lẫn Cow
func open_food_menu(animal = null) -> void:
	target_animal = animal
	show()
	center_on_screen()
	update_display()
	var animal_name = animal.name if animal else "Unknown"
	print("✅ FoodMenu mở cho: ", animal_name)

func center_on_screen() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	nine_patch_rect.position = (screen_size - nine_patch_rect.size) / 2

func update_display() -> void:
	var corn_count = InventoryManager.get_quantity("corn")
	var wheat_count = InventoryManager.get_quantity("wheat")
	
	qty_corn.text = str(corn_count)
	qty_wheat.text = str(wheat_count)
	
	print("FoodMenu - Cập nhật: Ngô = ", corn_count, " | Lúa mì = ", wheat_count)
	
	corn_food.modulate = Color(1,1,1,1) if corn_count >= 2 else Color(0.5,0.5,0.5,1)
	wheat_food.modulate = Color(1,1,1,1) if wheat_count >= 2 else Color(0.5,0.5,0.5,1)

# ================== CLICK CHO ĂN ==================
func _on_corn_food_pressed() -> void:
	if InventoryManager.has_enough("corn", 2):
		InventoryManager.remove_collectable("corn", 2)
		print("🍗 Đã cho ăn 2 Ngô")
		update_display()
		
		if target_animal and target_animal.has_method("feed"):
			target_animal.feed()
	else:
		print("❌ Không đủ Ngô")

func _on_wheat_food_pressed() -> void:
	if InventoryManager.has_enough("wheat", 2):
		InventoryManager.remove_collectable("wheat", 2)
		print("🍗 Đã cho ăn 2 Lúa mì")
		update_display()
		
		if target_animal and target_animal.has_method("feed"):
			target_animal.feed()
	else:
		print("❌ Không đủ Lúa mì")

func _on_exit_pressed() -> void:
	hide()
	print("Đóng FoodMenu")

func close_menu() -> void:
	hide()

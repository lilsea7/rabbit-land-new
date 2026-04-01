#extends Control
#
#@onready var corn_food: Button = $NinePatchRect/HBoxContainer/CornFood
#@onready var wheat_food: Button = $NinePatchRect/HBoxContainer/WheatFood
#@onready var btn_exit: Button = $NinePatchRect/HBoxContainer/BtnExit
#
#
#@onready var icon_corn: TextureRect = $NinePatchRect/HBoxContainer/CornFood/IconCorn
#@onready var qty_corn: Label = $NinePatchRect/HBoxContainer/CornFood/Quantity
#
#@onready var icon_wheat: TextureRect = $NinePatchRect/HBoxContainer/WheatFood/IconWheat
#@onready var qty_wheat: Label = $NinePatchRect/HBoxContainer/WheatFood/Quantity
#
#func _ready() -> void:
	## Kết nối các nút
	#if btn_exit:
		#btn_exit.pressed.connect(_on_exit_pressed)
	#else:
		#push_error("❌ Không tìm thấy ButtonExit!")
	#
	#if corn_food:
		#corn_food.gui_input.connect(_on_corn_food_clicked)
		#corn_food.mouse_filter = Control.MOUSE_FILTER_STOP
	#else:
		#push_error("❌ Không tìm thấy CornFood!")
	#
	#if wheat_food:
		#wheat_food.gui_input.connect(_on_wheat_food_clicked)
		#wheat_food.mouse_filter = Control.MOUSE_FILTER_STOP
	#else:
		#push_error("❌ Không tìm thấy WheatFood!")
	#
	#visible = false   # Ẩn UI ban đầu
#
#func update_display() -> void:
	#var corn_count = InventoryManager.get_quantity("Corn")
	#var wheat_count = InventoryManager.get_quantity("Wheat")
	#
	#qty_corn.text = str(corn_count)
	#qty_wheat.text = str(wheat_count)
	#
	## Làm mờ nếu không đủ 2
	#corn_food.modulate = Color(1,1,1,1) if corn_count >= 2 else Color(0.5,0.5,0.5,1)
	#wheat_food.modulate = Color(1,1,1,1) if wheat_count >= 2 else Color(0.5,0.5,0.5,1)
#
## ================== CLICK CHO ĂN NGÔ ==================
#func _on_corn_food_clicked(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#if InventoryManager.has_enough("Corn", 2):
			#InventoryManager.remove_collectable("Corn", 2)
			#print("🍗 Đã cho ăn 2 Ngô")
			#update_display()
			## TODO: Gọi hàm feed() của gà để tăng trạng thái
		#else:
			#print("❌ Không đủ Ngô để cho ăn!")
#
## ================== CLICK CHO ĂN LÚA MÌ ==================
#func _on_wheat_food_clicked(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#if InventoryManager.has_enough("Wheat", 2):
			#InventoryManager.remove_collectable("Wheat", 2)
			#print("🍗 Đã cho ăn 2 Lúa mì")
			#update_display()
			## TODO: Gọi hàm feed() của gà để tăng trạng thái
		#else:
			#print("❌ Không đủ Lúa mì để cho ăn!")
#
#func _on_exit_pressed() -> void:
	#visible = false
	#print("Đóng FoodMenu")
#
## Hàm này sẽ được gọi từ Chicken.gd khi player bấm E
#func open_food_menu() -> void:
	#visible = true
	#update_display()
	#print("✅ FoodMenu đã được mở từ Chicken")
	
extends CanvasLayer

# ================== NODE ==================
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var corn_food: Button = $NinePatchRect/HBoxContainer/CornFood
@onready var wheat_food: Button = $NinePatchRect/HBoxContainer/WheatFood

@onready var qty_corn: Label = $NinePatchRect/HBoxContainer/CornFood/QuantityCorn
@onready var qty_wheat: Label = $NinePatchRect/HBoxContainer/WheatFood/QuantityWheat

# ================== DATA ==================
var target_chicken: Chicken = null


# ================== READY ==================
func _ready() -> void:
	print("=== FOOD MENU (CanvasLayer) _READY() ===")

	# Button setup
	if corn_food:
		corn_food.pressed.connect(_on_corn_food_pressed)
		corn_food.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if wheat_food:
		wheat_food.pressed.connect(_on_wheat_food_pressed)
		wheat_food.mouse_filter = Control.MOUSE_FILTER_STOP
	
	hide()  # Ẩn ban đầu


# ================== OPEN MENU ==================
func open_food_menu(chicken: Chicken = null) -> void:
	target_chicken = chicken   # 🔥 nhận chicken từ bên ngoài
	
	show()
	center_on_screen()
	update_display()
	
	print("✅ FoodMenu mở | target_chicken =", target_chicken)


# ================== CENTER UI ==================
func center_on_screen() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	nine_patch_rect.position = (screen_size - nine_patch_rect.size) / 2


# ================== UPDATE UI ==================
func update_display() -> void:
	var corn_count = InventoryManager.get_quantity("corn")
	var wheat_count = InventoryManager.get_quantity("wheat")
	
	qty_corn.text = str(corn_count)
	qty_wheat.text = str(wheat_count)
	
	print("FoodMenu - Cập nhật: Ngô =", corn_count, "| Lúa mì =", wheat_count)
	
	# Disable nếu không đủ
	corn_food.disabled = corn_count < 2
	wheat_food.disabled = wheat_count < 2
	
	# Visual
	corn_food.modulate = Color(1,1,1,1) if corn_count >= 2 else Color(0.5,0.5,0.5,1)
	wheat_food.modulate = Color(1,1,1,1) if wheat_count >= 2 else Color(0.5,0.5,0.5,1)


# ================== FEED CORN ==================
func _on_corn_food_pressed() -> void:
	print("🔥 CORN BUTTON CLICKED!")

	if not InventoryManager.has_enough("corn", 2):
		print("❌ Không đủ Ngô")
		return

	InventoryManager.remove_collectable("corn", 2)
	print("🍗 Đã cho gà ăn 2 Ngô")

	# 🔥 GỌI CHICKEN
	if target_chicken:
		target_chicken.feed()
	else:
		print("❌ target_chicken NULL")

	update_display()


# ================== FEED WHEAT ==================
func _on_wheat_food_pressed() -> void:
	print("🔥 WHEAT BUTTON CLICKED!")

	if not InventoryManager.has_enough("wheat", 2):
		print("❌ Không đủ Lúa mì")
		return

	InventoryManager.remove_collectable("wheat", 2)
	print("🍗 Đã cho gà ăn 2 Lúa mì")

	# 🔥 GỌI CHICKEN
	if target_chicken:
		target_chicken.feed()
	else:
		print("❌ target_chicken NULL")

	update_display()


# ================== CLOSE ==================
func _on_exit_pressed() -> void:
	close_menu()

func close_menu() -> void:
	hide()
	print("🔒 Đóng FoodMenu")

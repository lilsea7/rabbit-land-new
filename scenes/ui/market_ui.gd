extends Control

@onready var button_close: Button = $ButtonClose


# Danh sách các Panel chứa hạt giống (Wheat, Tomato, Carrot, Corn, Rose, Broccoli)
@onready var seed_panels = {
	"wheat": $NinePatchRect/ScrollContainer/VBoxContainer/Wheat,
	"tomato": $NinePatchRect/ScrollContainer/VBoxContainer/Tomato,
	"carrot": $NinePatchRect/ScrollContainer/VBoxContainer/Carrot,
	"corn": $NinePatchRect/ScrollContainer/VBoxContainer/Corn,
	"rose": $NinePatchRect/ScrollContainer/VBoxContainer/Rose,
	"broccoli": $NinePatchRect/ScrollContainer/VBoxContainer/Broccoli
}

# Giá bán của từng hạt giống 
var seed_prices = {
	"wheat": 5,
	"tomato": 8,
	"carrot": 10,
	"corn": 5,
	"rose": 20,
	"broccoli": 15
}

func _ready() -> void:
	if button_close:
		button_close.pressed.connect(_on_close_pressed)
	
	# Kết nối tất cả ButtonBuy
	_connect_buy_buttons()
	
	# Cập nhật tiền ban đầu
	#update_gold_label()
	
	# Kết nối signal tiền thay đổi
	#if ShopManager:
		#ShopManager.money_changed.connect(update_gold_label)

func _connect_buy_buttons() -> void:
	for seed_name in seed_panels:
		var panel = seed_panels[seed_name]
		var buy_button = panel.get_node_or_null("ButtonBuy")
		if buy_button:
			buy_button.pressed.connect(_on_buy_seed.bind(seed_name))
			#print("Đã kết nối ButtonBuy cho: ", seed_name)

# Mở Market
func open_market() -> void:
	visible = true
	#update_display()           # Cập nhật coin, danh sách hạt giống...
	print("Market UI đã được mở và cập nhật")

## Cập nhật số coin
#func update_gold_label() -> void:
	#if gold_label:
		#gold_label.text = "Coin: " + str(ShopManager.player_money)

# ================== XỬ LÝ MUA HẠT GIỐNG ==================
func _on_buy_seed(seed_name: String) -> void:
	var price = seed_prices.get(seed_name, 20)
	
	if ShopManager.spend_money(price):
		# Cộng hạt giống vào Inventory
		var seed_item_name = seed_name + "_seed"
		InventoryManager.add_collectable(seed_item_name, 1)
		
		print("✅ Đã mua 1 ", seed_name.capitalize(), "_seed với giá ", price, " coin")
		
		# Cập nhật Plants UI nếu đang mở
		var plants_ui = get_tree().get_first_node_in_group("PlantsUI")
		if plants_ui and plants_ui.has_method("update_display"):
			plants_ui.update_display()
			
	else:
		print("❌ Không đủ coin để mua ", seed_name)

func _on_close_pressed() -> void:
	visible = false
	print("Market UI đã đóng")
	SoundManager.play_button_click()

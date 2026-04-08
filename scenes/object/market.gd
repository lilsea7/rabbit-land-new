# market.gd
extends Node2D
class_name Market

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool = false

# Reference đến MarketUI đã add sẵn trong Game Screen
var market_ui: Control = null

func _ready() -> void:
	print("🏪 Market _ready()")
	
	if interactable_component:
		interactable_component.interactable_activated.connect(on_interactable_activated)
		interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	
	if interactable_label_component:
		interactable_label_component.hide()
	
	# Tìm MarketUI đã add sẵn trong scene (chỉ tìm 1 lần)
	_find_market_ui()

# Tìm MarketUI đã add sẵn
func _find_market_ui() -> void:
	# Thử các đường dẫn phổ biến
	market_ui = get_tree().root.get_node_or_null("Main/UILayer/MarketUI")
	if not market_ui:
		market_ui = get_tree().root.get_node_or_null("UILayer/MarketUI")
	if not market_ui:
		market_ui = get_tree().root.find_child("MarketUI", true, false)
	if not market_ui:
		market_ui = get_tree().root.find_child("ShopUI", true, false)  # nếu tên là ShopUI
	
	if market_ui:
		print("✅ Đã tìm thấy MarketUI sẵn trong scene")
		market_ui.visible = false  # Ẩn ban đầu
	else:
		push_error("❌ Không tìm thấy MarketUI trong scene! Kiểm tra lại tên node và vị trí.")

func on_interactable_activated() -> void:
	if interactable_label_component:
		interactable_label_component.show()
	in_range = true
	print("👉 Player vào vùng Market")

func on_interactable_deactivated() -> void:
	if interactable_label_component:
		interactable_label_component.hide()
	in_range = false
	print("👈 Player rời vùng Market")
	
	# Tự động ẩn Market UI khi rời vùng
	if market_ui and is_instance_valid(market_ui):
		market_ui.visible = false

# ================== TƯƠNG TÁC KHI BẤM E ==================
func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("interact"):
		interact()

# ================== INTERACT - KIỂM TRA LEVEL 5 ==================
func interact() -> void:
	if not in_range:
		return
	
	if not LevelManager or not LevelManager.has_method("is_unlocked"):
		print("⚠️ LevelManager chưa sẵn sàng!")
		return
	
	# Kiểm tra unlock Level 5
	if not LevelManager.is_unlocked("shop_market"):
		print("❌ Chợ chưa được mở khóa! Cần đạt Level 5.")
		return
	
	# Mở Market UI đã add sẵn
	if market_ui and is_instance_valid(market_ui):
		market_ui.visible = true
		
		# Gọi hàm mở nếu có (open_shop hoặc open_market)
		if market_ui.has_method("open_shop"):
			market_ui.open_shop()
		elif market_ui.has_method("open_market"):
			market_ui.open_market()
		
		print("✅ Đã mở Market UI (đã add sẵn trong Game Screen)")
	else:
		push_error("❌ Không tìm thấy MarketUI! Kiểm tra lại scene tree.")

# Hàm hỗ trợ
func is_interactable() -> bool:
	return LevelManager.is_unlocked("shop_market")

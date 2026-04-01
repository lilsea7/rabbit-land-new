## shop_manager.gd
#extends Node
#
## Giá bán của từng vật phẩm (bạn có thể chỉnh thoải mái)
#var sell_prices: Dictionary = {
	#"wheat": 25,
	#"tomato": 30,
	#"broccoli": 35,
	#"carrot": 28,
	#"corn": 32,
	#"rose": 40,
	#"log": 15,
	#"stone": 10,
	## Thêm các vật phẩm khác ở đây...
#}
#
#var player_money: int = 500
#
#signal money_changed(new_amount: int)
#
#func get_sell_price(item_name: String) -> int:
	#return sell_prices.get(item_name.to_lower(), 10)  # mặc định 10 nếu chưa có
#
#func sell_item(item_name: String, quantity: int) -> bool:
	#if quantity <= 0:
		#return false
	#
	#var current_qty = InventoryManager.inventory.get(item_name, 0)
	#if current_qty < quantity:
		#print("Không đủ số lượng để bán!")
		#return false
	#
	#var price = get_sell_price(item_name)
	#var total_money = price * quantity
	#
	## Trừ vật phẩm
	#InventoryManager.inventory[item_name] -= quantity
	#if InventoryManager.inventory[item_name] <= 0:
		#InventoryManager.inventory.erase(item_name)
	#
	## Cộng tiền
	#player_money += total_money
	#money_changed.emit(player_money)
	#
	#print("Đã bán ", quantity, "x ", item_name, " với giá ", total_money)
	#return true

# shop_manager.gd
extends Node

# ================== GIÁ BÁN VẬT PHẨM ==================
var sell_prices: Dictionary = {
	"wheat": 25,
	"tomato": 30,
	"broccoli": 35,
	"carrot": 28,
	"corn": 32,
	"rose": 40,
	"log": 15,
	"stone": 10,
	# Thêm vật phẩm mới ở đây...
}

var player_money: int = 50

signal money_changed(new_amount: int)

func _ready() -> void:
	print("ShopManager đã khởi tạo - Tiền ban đầu: ", player_money)

# Lấy giá bán của vật phẩm
func get_sell_price(item_name: String) -> int:
	return sell_prices.get(item_name.to_lower(), 10)  # mặc định 10 nếu chưa có giá

# Hàm bán vật phẩm - Đã được tối ưu và an toàn hơn
func sell_item(item_name: String, quantity: int) -> bool:
	if quantity <= 0:
		print("Số lượng bán phải lớn hơn 0")
		return false
	
	var current_qty = InventoryManager.inventory.get(item_name, 0)
	if current_qty < quantity:
		print("Không đủ ", quantity, " ", item_name, " để bán! (Hiện có: ", current_qty, ")")
		return false
	
	var price_per_unit = get_sell_price(item_name)
	var total_earn = price_per_unit * quantity
	
	# Trừ vật phẩm trong inventory
	InventoryManager.inventory[item_name] -= quantity
	if InventoryManager.inventory[item_name] <= 0:
		InventoryManager.inventory.erase(item_name)
	
	# Cộng tiền
	player_money += total_earn
	
	# Emit signal để cập nhật UI
	money_changed.emit(player_money)
	
	print("✅ Đã bán ", quantity, "x ", item_name, " | Nhận được ", total_earn, " tiền | Tổng tiền: ", player_money)
	
	return true

# ================== CÁC HÀM HỖ TRỢ THÊM (Coin) ==================

# Thêm tiền trực tiếp (dùng cho quest, bán NPC, phần thưởng...)
func add_money(amount: int) -> void:
	if amount <= 0:
		return
	player_money += amount
	money_changed.emit(player_money)
	print("Nhận thêm ", amount, " tiền từ nguồn khác. Tổng: ", player_money)

# Trừ tiền (mua đồ, chi phí...)
func spend_money(amount: int) -> bool:
	if amount <= 0:
		return false
	if player_money < amount:
		print("Không đủ tiền! Cần ", amount, " mà chỉ có ", player_money)
		return false
	
	player_money -= amount
	money_changed.emit(player_money)
	print("Đã chi ", amount, " tiền. Còn lại: ", player_money)
	return true

# Lấy số tiền hiện tại
func get_current_money() -> int:
	return player_money

#extends Node
#
#var inventory: Dictionary = Dictionary()
#
#signal inventory_changed
#
#func add_collectable(collectable_name: String) -> void:
	#inventory.get_or_add(collectable_name)
	#
	#if inventory[collectable_name] == null:
		#inventory[collectable_name] = 1
	#else:
		#inventory[collectable_name] += 1
		#
	#inventory_changed.emit()
#
#func remove_collectable(collectable_name: String) -> void:
	#inventory.get_or_add(collectable_name)
	#
	#if inventory[collectable_name] == null:
		#inventory[collectable_name] = 0
	#else:
		#if inventory[collectable_name] > 0:
			#inventory[collectable_name] -= 1
		#
	#inventory_changed.emit()

extends Node

var inventory: Dictionary = {}      # Key: tên vật phẩm, Value: số lượng
signal inventory_changed

# Khởi tạo mặc định tất cả vật phẩm là 0
func _ready() -> void:
	# Danh sách các vật phẩm bạn muốn có trong game
	var default_items = [
		"Wheat", "Tomato", "Carrot", "Corn", 
		"Rose", "Sunflower", "Log", "Stone"
	]
	
	for item_name in default_items:
		if not inventory.has(item_name):
			inventory[item_name] = 0

# Thêm vật phẩm (cộng dồn số lượng)
func add_collectable(collectable_name: String, amount: int = 1) -> void:
	if collectable_name == "":
		return
	
	# Nếu chưa có thì khởi tạo = 0
	if not inventory.has(collectable_name):
		inventory[collectable_name] = 0
	
	inventory[collectable_name] += amount
	
	# Phát signal để UI cập nhật
	inventory_changed.emit()
	
	print("Thu thập: ", collectable_name, " +", amount, " → Tổng: ", inventory[collectable_name])

# Giảm vật phẩm
func remove_collectable(collectable_name: String, amount: int = 1) -> void:
	if collectable_name == "" or not inventory.has(collectable_name):
		return
	
	inventory[collectable_name] -= amount
	
	# Không cho số lượng âm
	if inventory[collectable_name] < 0:
		inventory[collectable_name] = 0
	
	inventory_changed.emit()
	
	print("Sử dụng: ", collectable_name, " -", amount, " → Còn: ", inventory[collectable_name])

# Lấy số lượng hiện tại
func get_quantity(collectable_name: String) -> int:
	return inventory.get(collectable_name, 0)

# Kiểm tra có đủ số lượng không
func has_enough(collectable_name: String, amount: int) -> bool:
	return get_quantity(collectable_name) >= amount

# Thêm tiền cho người chơi
var money: int = 100   # Số tiền ban đầu

func add_money(amount: int) -> void:
	money += amount
	# Có thể emit signal nếu bạn có UI tiền
	print("Tiền hiện tại: ", money)

# Lấy số tiền hiện tại
func get_money() -> int:
	return money

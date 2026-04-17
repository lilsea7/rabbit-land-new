extends Node

var inventory: Dictionary = {} 
signal inventory_changed

func _ready() -> void:
	var default_items = [
		"wheat", "tomato", "carrot", "corn",
		"rose", "sunflower", "log", "stone",
		"wheat_seed", "tomato_seed", "carrot_seed", 
		"corn_seed", "rose_seed", "broccoli_seed"
	]
	
	for item_name in default_items:
		if not inventory.has(item_name):
			inventory[item_name] = 0

func add_collectable(collectable_name: String, amount: int = 1) -> void:
	if collectable_name == "":
		return
	if not inventory.has(collectable_name):
		inventory[collectable_name] = 0
	inventory[collectable_name] += amount
	inventory_changed.emit()
	print("Thu thập: ", collectable_name, " +", amount, " → Tổng: ", inventory[collectable_name])

func remove_collectable(collectable_name: String, amount: int = 1) -> void:
	if collectable_name == "" or not inventory.has(collectable_name):
		return
	inventory[collectable_name] -= amount
	if inventory[collectable_name] < 0:
		inventory[collectable_name] = 0
	inventory_changed.emit()
	print("Sử dụng: ", collectable_name, " -", amount, " → Còn: ", inventory[collectable_name])

func get_quantity(collectable_name: String) -> int:
	return inventory.get(collectable_name, 0)

func has_enough(collectable_name: String, amount: int) -> bool:
	return get_quantity(collectable_name) >= amount

func get_inventory() -> Dictionary:
	return inventory.duplicate(true)   # duplicate để tránh reference


func set_inventory(new_inventory: Dictionary) -> void:
	inventory = new_inventory.duplicate(true)
	inventory_changed.emit()      
	#print("📦 Inventory đã được load lại với ", inventory.size(), " loại vật phẩm")


var money: int

func add_money(amount: int) -> void:
	if amount <= 0:
		return
	money += amount
	print("Tiền hiện tại: ", money)

func get_money() -> int:
	return money

func spend_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		return true
	return false

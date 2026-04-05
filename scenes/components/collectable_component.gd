class_name CollectableComponent
extends Area2D

@export var collectable_name: String = ""   # Ví dụ: "egg", "milk", "log", "stone"...
@export var quantity: int = 1

func _ready() -> void:
	monitoring = true
	monitorable = true
	
	# Kết nối signal an toàn
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	print("Collectable spawned: ", collectable_name, " tại vị trí ", global_position)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and collectable_name != "":
		print("Player chạm vào collectable: ", collectable_name)
		
		# ================== THÊM EXP TẠI ĐÂY ==================
		match collectable_name.to_lower():   # Dùng to_lower() để tránh lỗi hoa/thường
			"corn":
				LevelManager.add_exp(LevelManager.exp_rewards["harvest_crop"], "harvest_crop")
			"egg":
				LevelManager.add_exp(LevelManager.exp_rewards["harvest_egg"], "harvest_egg")
			"milk":
				LevelManager.add_exp(LevelManager.exp_rewards["harvest_milk"], "harvest_milk")
			"log":
				LevelManager.add_exp(LevelManager.exp_rewards.get("chop_tree", 5), "chop_tree")
			"stone":
				LevelManager.add_exp(LevelManager.exp_rewards.get("mine_stone", 5), "mine_stone")
			# Thêm các vật phẩm khác sau này
			_:
				print("Không có exp reward cho vật phẩm: ", collectable_name)
		
		# Thu thập vật phẩm vào Inventory
		if InventoryManager:
			InventoryManager.add_collectable(collectable_name, quantity)
			print("Đã thu thập: ", collectable_name, " x", quantity)
		else:
			push_error("InventoryManager không tồn tại!")
		
		# Xóa vật phẩm sau khi thu thập
		get_parent().queue_free()
	else:
		print("Body chạm nhưng không phải Player hoặc collectable_name rỗng")

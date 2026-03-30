#class_name CollactableComponent
#extends Area2D
#
#@export var collactable_name: String
#
#func _on_body_entered(body: Node2D) -> void:
	#if body is Player:
		#InventoryManager.add_collectable(collactable_name)
		#print("Collected: " + collactable_name)
		#get_parent().queue_free()

#class_name CollectableComponent
#extends Area2D
#
#@export var collectable_name: String = ""   # Tên vật phẩm (Wheat, Log, Stone, Carrot...)
#@export var quantity: int = 1               # Số lượng thu được mỗi lần
#
#func _on_body_entered(body: Node2D) -> void:
	#if body is Player and collectable_name != "":
		#
		## Kiểm tra InventoryManager tồn tại trước khi gọi
		#if InventoryManager:
			#InventoryManager.add_collectable(collectable_name, quantity)
			#print("Thu thập: ", collectable_name, " x", quantity)
		#else:
			#push_error("InventoryManager không tồn tại! Không thể thu thập vật phẩm.")
		#
		## Xóa vật phẩm sau khi thu thập thành công
		#get_parent().queue_free()

class_name CollectableComponent
extends Area2D

@export var collectable_name: String = ""   # Ví dụ: "Log", "Stone", "Wheat"
@export var quantity: int = 1

func _ready() -> void:
	# Bật monitoring để Area2D có thể detect collision
	monitoring = true
	monitorable = true
	
	# Kết nối signal bằng code để chắc chắn (nếu chưa connect trong editor)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	print("Collectable spawned: ", collectable_name, " tại vị trí ", global_position)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and collectable_name != "":
		print("Player chạm vào collectable: ", collectable_name)
		
		if InventoryManager:
			InventoryManager.add_collectable(collectable_name, quantity)
			print("Đã thu thập: ", collectable_name, " x", quantity)
		else:
			push_error("InventoryManager không tồn tại! Không thể thu thập vật phẩm.")
		
		# Xóa vật phẩm sau khi thu thập
		get_parent().queue_free()
	else:
		print("Body chạm nhưng không phải Player hoặc collectable_name rỗng")

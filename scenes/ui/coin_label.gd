# coin_label.gd
extends Label
class_name CoinLabel

func _ready() -> void:
	# Đảm bảo text ban đầu đúng
	text = str(ShopManager.player_money)
	
	# Kết nối signal từ ShopManager
	if ShopManager and not ShopManager.money_changed.is_connected(_on_money_changed):
		ShopManager.money_changed.connect(_on_money_changed)
	
	print("✅ CoinLabel đã sẵn sàng")

# Hàm tự động chạy mỗi khi tiền thay đổi
func _on_money_changed(new_amount: int) -> void:
	text = str(new_amount)
	# Optional: thêm hiệu ứng nhỏ khi tiền tăng
	# modulate = Color.YELLOW
	# await get_tree().create_timer(0.3).timeout
	# modulate = Color.WHITE

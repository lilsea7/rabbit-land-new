#extends PanelContainer
#
#@export var item: Item:                     # Resource bạn đã gán sẵn trong Editor
	#set(value):
		#item = value
		#_update_display()
#
#@onready var icon_node: TextureRect = $Icon
#@onready var quantity_label: Label = $QuantityLabel
#
#func _ready() -> void:
	#_update_display()
#
## Hàm quan trọng: được gọi từ InventoryUI để cập nhật số lượng
#func update_quantity(new_quantity: int) -> void:
	#if item != null:
		#item.quantity = new_quantity          # ← Cập nhật trực tiếp vào Resource
	#
	#_update_display()                         # Refresh hiển thị
#
## Cập nhật icon + số lượng
#func _update_display() -> void:
	## Icon
	#if icon_node:
		#if item != null and item.icon != null:
			#icon_node.texture = item.icon
			#icon_node.visible = true
		#else:
			#icon_node.visible = false
	#
	## Số lượng
	#if quantity_label:
		#var qty = item.quantity if item != null else 0
		#if qty > 0:
			#quantity_label.text = str(qty)
			#quantity_label.visible = true
		#else:
			#quantity_label.text = ""
			#quantity_label.visible = false
#
## Hover (giữ nguyên)
#func _on_mouse_entered() -> void:
	#if item != null and owner != null and owner.has_method("set_description"):
		#owner.set_description(item)
#
#func _on_mouse_exited() -> void:
	#if owner != null and owner.has_method("clear_description"):
		#owner.clear_description()

extends PanelContainer

@export var item: Item:
	set(value):
		item = value
		_update_display()

@onready var icon_node: TextureRect = $Icon
@onready var quantity_label: Label = $QuantityLabel

# Thêm signal pressed để ShopUI có thể kết nối
signal pressed

func _ready() -> void:
	_update_display()
	mouse_filter = Control.MOUSE_FILTER_STOP  # Cho phép nhận click

# Hàm quan trọng: được gọi từ InventoryUI và ShopUI để cập nhật số lượng
func update_quantity(new_quantity: int) -> void:
	if item == null:
		item = Item.new()
		item.title = "Unknown"
	
	item.quantity = new_quantity
	_update_display()

# Cập nhật icon + số lượng
func _update_display() -> void:
	# Icon
	if icon_node:
		if item != null and item.icon != null:
			icon_node.texture = item.icon
			icon_node.visible = true
		else:
			icon_node.texture = null
			icon_node.visible = false
	
	# Số lượng
	if quantity_label:
		var qty = item.quantity if item != null else 0
		if qty > 0:
			quantity_label.text = str(qty)
			quantity_label.visible = true
		else:
			quantity_label.text = ""
			quantity_label.visible = false

# Hover vào slot
func _on_mouse_entered() -> void:
	if item != null and owner != null and owner.has_method("set_description"):
		owner.set_description(item)

# Rời chuột khỏi slot
func _on_mouse_exited() -> void:
	if owner != null and owner.has_method("clear_description"):
		owner.clear_description()

# Xử lý click chuột trái để phát signal "pressed"
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("pressed")

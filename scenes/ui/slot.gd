#extends PanelContainer
#
#@export var item: Item:
	#set(value):
		#item = value
		#_update_display()
#
#@onready var icon_node: TextureRect = $Icon
#@onready var quantity_label: Label = $QuantityLabel   # ← Thêm dòng này
#
#func _ready() -> void:
	#_update_display()
#
#func _update_display() -> void:
	## Cập nhật icon
	#if icon_node:
		#if item != null and item.icon != null:
			#icon_node.texture = item.icon
			#icon_node.visible = true
		#else:
			#icon_node.texture = null
			#icon_node.visible = false
	#
	## Cập nhật số lượng
	#if quantity_label:
		#if item != null and item.quantity > 0:
			#quantity_label.text = str(item.quantity)
			#quantity_label.visible = true
		#else:
			#quantity_label.text = ""
			#quantity_label.visible = false
#
#func _on_mouse_entered() -> void:
	#if item != null and owner != null:
		#owner.set_description(item)

#extends PanelContainer
#
#@export var item: Item:
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
#func _update_display() -> void:
	## Cập nhật Icon
	#if icon_node:
		#if item != null and item.icon != null:
			#icon_node.texture = item.icon
			#icon_node.visible = true
		#else:
			#icon_node.texture = null
			#icon_node.visible = false
	#
	## Cập nhật số lượng (phần bạn yêu cầu)
	#if quantity_label:
		#if item != null and item.quantity > 1:           # Chỉ hiển thị khi > 1
			#quantity_label.text = str(item.quantity)
			#quantity_label.visible = true
		#else:
			#quantity_label.text = ""
			#quantity_label.visible = false
#
## Hover vào slot để hiển thị mô tả
#func _on_mouse_entered() -> void:
	#if item != null and owner != null and owner.has_method("set_description"):
		#owner.set_description(item)
#
## Rời chuột khỏi slot → ẩn mô tả (tùy chọn nhưng nên có)
#func _on_mouse_exited() -> void:
	#if owner != null and owner.has_method("clear_description"):
		#owner.clear_description()

#extends PanelContainer
#
#@export var item: Item:
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
## Cập nhật toàn bộ hiển thị (icon + số lượng)
#func _update_display() -> void:
	## Cập nhật Icon
	#if icon_node:
		#if item != null and item.icon != null:
			#icon_node.texture = item.icon
			#icon_node.visible = true
		#else:
			#icon_node.texture = null
			#icon_node.visible = false
	#
	## Cập nhật số lượng
	#_update_quantity()
#
## Hàm cập nhật riêng số lượng (sẽ được gọi từ InventoryUI)
#func update_quantity(new_quantity: int) -> void:
	#if quantity_label:
		#if new_quantity > 0:
			#quantity_label.text = str(new_quantity)
			#quantity_label.visible = true
		#else:
			#quantity_label.text = ""
			#quantity_label.visible = false
#
## Hàm nội bộ cập nhật số lượng từ item
#func _update_quantity() -> void:
	#if quantity_label:
		#var qty = item.quantity if item != null else 0
		#if qty > 0:
			#quantity_label.text = str(qty)
			#quantity_label.visible = true
		#else:
			#quantity_label.text = ""
			#quantity_label.visible = false
#
## Hover vào slot
#func _on_mouse_entered() -> void:
	#if item != null and owner != null and owner.has_method("set_description"):
		#owner.set_description(item)
#
## Rời chuột khỏi slot
#func _on_mouse_exited() -> void:
	#if owner != null and owner.has_method("clear_description"):
		#owner.clear_description()

extends PanelContainer

@export var item: Item:                     # Resource bạn đã gán sẵn trong Editor
	set(value):
		item = value
		_update_display()

@onready var icon_node: TextureRect = $Icon
@onready var quantity_label: Label = $QuantityLabel

func _ready() -> void:
	_update_display()

# Hàm quan trọng: được gọi từ InventoryUI để cập nhật số lượng
func update_quantity(new_quantity: int) -> void:
	if item != null:
		item.quantity = new_quantity          # ← Cập nhật trực tiếp vào Resource
	
	_update_display()                         # Refresh hiển thị

# Cập nhật icon + số lượng
func _update_display() -> void:
	# Icon
	if icon_node:
		if item != null and item.icon != null:
			icon_node.texture = item.icon
			icon_node.visible = true
		else:
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

# Hover (giữ nguyên)
func _on_mouse_entered() -> void:
	if item != null and owner != null and owner.has_method("set_description"):
		owner.set_description(item)

func _on_mouse_exited() -> void:
	if owner != null and owner.has_method("clear_description"):
		owner.clear_description()

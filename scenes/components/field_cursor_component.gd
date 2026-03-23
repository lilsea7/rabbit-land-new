#class_name FieldCursorComponent
#extends Node
#
#@export var grass_tilemap_layer: TileMapLayer
#@export var tilled_soil_tilemap_layer: TileMapLayer
#@export var terrain_set: int = 0
#@export var terrain: int = 3
#
#var player: Player
#
#var mouse_position: Vector2
#var cell_position: Vector2i
#var cell_source_id: int
#var local_cell_position: Vector2
#var distance: float
#
#func _ready() -> void:
	#await get_tree().process_frame
	#player = get_tree().get_first_node_in_group("player")
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("remove_dirt"):
		#if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			#get_cell_under_mouse()
			#remove_tilled_soil_cell()
			#
	#elif event.is_action_pressed("hit"):
		#if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			#get_cell_under_mouse()
			#add_tilled_soil_cell()
			#
#func get_cell_under_mouse() -> void:
	#mouse_position = grass_tilemap_layer.get_local_mouse_position()
	#cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	#cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	#local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	#distance = player.global_position.distance_to(local_cell_position)
#
	#
#func add_tilled_soil_cell() -> void:
	#if distance < 20.0 && cell_source_id != -1:
		#tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)
#
#func remove_tilled_soil_cell() -> void:
	#if distance < 20.0:
		#tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)

#class_name FieldCursorComponent
#extends Node
#
#@export var grass_tilemap_layer: TileMapLayer
#@export var tilled_soil_tilemap_layer: TileMapLayer
#@export var terrain_set: int = 0
#@export var terrain: int = 3
#
## Thêm các export cho scene cây trồng (bạn tạo sẵn scene wheat.tscn, tomato.tscn...)
#@export var wheat_plant_scene: PackedScene
#@export var tomato_plant_scene: PackedScene
## Thêm các loại khác nếu cần (carrot_plant_scene, corn_plant_scene...)
#
#var player: Player
#var mouse_position: Vector2
#var cell_position: Vector2i
#var cell_source_id: int
#var local_cell_position: Vector2
#var distance: float
#
#func _ready() -> void:
	#await get_tree().process_frame
	#player = get_tree().get_first_node_in_group("player")
	#if player == null:
		#push_error("Không tìm thấy Player trong group 'player'!")
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("remove_dirt"):
		#if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			#get_cell_under_mouse()
			#remove_tilled_soil_cell()
	#
	#elif event.is_action_pressed("hit"):
		#get_cell_under_mouse()
		#
		#if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			#add_tilled_soil_cell()
		#
		#elif ToolManager.selected_tool in [DataTypes.Tools.PlantWheat, DataTypes.Tools.PlantTomato]:
			#if distance < 20.0:
				#plant_seed()
#
## Lấy vị trí ô dưới con trỏ chuột
#func get_cell_under_mouse() -> void:
	#mouse_position = grass_tilemap_layer.get_local_mouse_position()
	#cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	#cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	#local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	#distance = player.global_position.distance_to(local_cell_position)
#
## Cày đất (giữ nguyên)
#func add_tilled_soil_cell() -> void:
	#if distance < 20.0 && cell_source_id != -1:
		#tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)
#
## Xóa đất cày (giữ nguyên)
#func remove_tilled_soil_cell() -> void:
	#if distance < 20.0:
		#tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
#
## Hàm gieo hạt giống (phần mới)
#func plant_seed() -> void:
	## Kiểm tra ô dưới chuột có phải đất đã cày không
	#var tile_data = tilled_soil_tilemap_layer.get_cell_tile_data(cell_position)
	#if tile_data == null or tile_data.get_terrain() != terrain:
		#print("Ô này chưa được cày hoặc không phải đất trồng!")
		#return
	#
	## Lấy loại hạt giống đang chọn
	#var seed_type = ToolManager.current_seed_type
	#if seed_type == "":
		#print("Chưa chọn loại hạt giống!")
		#return
	#
	## Tạo cây giống tương ứng
	#var plant_scene: PackedScene = null
	#match seed_type:
		#"Wheat":
			#plant_scene = wheat_plant_scene
		#"Tomato":
			#plant_scene = tomato_plant_scene
		#_:
			#print("Không hỗ trợ loại hạt giống: ", seed_type)
			#return
	#
	#if plant_scene == null:
		#print("Chưa gán scene cây cho ", seed_type)
		#return
	#
	## Instantiate cây
	#var plant = plant_scene.instantiate()
	#
	## Đặt vị trí chính giữa ô tile (giả sử tile size 16x16)
	#plant.position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	#
	## Add vào node chứa cây (thường là một Node2D tên PlantsRoot trong Level)
	## Bạn cần tạo node PlantsRoot trong scene level và add vào đó
	#var plants_root = get_tree().current_scene.get_node("PlantsRoot")  # điều chỉnh đường dẫn
	#if plants_root:
		#plants_root.add_child(plant)
	#else:
		#get_tree().current_scene.add_child(plant)  # fallback
	#
	#print("Đã gieo ", seed_type, " tại ô ", cell_position)
	#
	## Reset tool sau khi gieo (tùy chọn - để tránh gieo liên tục)
	#ToolManager.selecet_tool(DataTypes.Tools.None)

class_name FieldCursorComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 3

# Thêm các export cho scene cây trồng
@export var wheat_plant_scene: PackedScene
@export var tomato_plant_scene: PackedScene
# Thêm các loại khác nếu cần

var player: Player
var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_error("Không tìm thấy Player trong group 'player'!")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()
	
	elif event.is_action_pressed("hit"):
		get_cell_under_mouse()
		
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			add_tilled_soil_cell()
		
		elif ToolManager.selected_tool in [DataTypes.Tools.PlantWheat, DataTypes.Tools.PlantTomato]:
			if distance < 20.0:
				if is_tilled_soil():
					plant_seed()
				else:
					print("Ô này chưa được cày! Không thể trồng.")
					# Quan trọng: KHÔNG gọi plant_seed() ở đây → ngăn gieo
			else:
				print("Quá xa để trồng!")

# Lấy vị trí ô dưới con trỏ chuột (giữ nguyên)
func get_cell_under_mouse() -> void:
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)

# Cày đất (giữ nguyên)
func add_tilled_soil_cell() -> void:
	if distance < 20.0 && cell_source_id != -1:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)

# Xóa đất cày (giữ nguyên)
func remove_tilled_soil_cell() -> void:
	if distance < 20.0:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)

# Kiểm tra ô có phải đất đã cày không (phần mới quan trọng)
func is_tilled_soil() -> bool:
	# Lấy tile data từ tilled_soil_layer tại vị trí cell
	var tile_data = tilled_soil_tilemap_layer.get_cell_tile_data(cell_position)
	
	# Nếu có tile data và terrain khớp với đất cày (terrain = 3)
	if tile_data != null and tile_data.get_terrain() == terrain:
		return true
	
	print("Ô không phải đất đã cày (terrain: ", tile_data.get_terrain() if tile_data else "null", ")")
	return false

# Gieo hạt giống (phần mới)
func plant_seed() -> void:
	var seed_type = ToolManager.current_seed_type
	if seed_type == "":
		print("Chưa chọn loại hạt giống!")
		return
	
	# Kiểm tra số lượng hạt giống còn lại (từ PlantsUI hoặc Inventory)
	var plants_ui = get_tree().root.find_child("PlantsUI", true, false)
	if plants_ui == null:
		print("Không tìm thấy PlantsUI!")
		return
	
	var quantity = plants_ui.seed_inventory.get(seed_type, 0)
	if quantity <= 0:
		print("Hết hạt giống ", seed_type, "! Không thể trồng thêm.")
		# Tùy chọn: reset tool hoặc hiện thông báo
		ToolManager.selecet_tool(DataTypes.Tools.None)
	return
	
	# Trừ 1 hạt
	plants_ui.seed_inventory[seed_type] -= 1
	plants_ui.update_quantity_label("Slot" + seed_type)  # Update UI ngay
	
	# Gieo cây
	var plant_scene = null
	match seed_type:
		"Wheat":
			plant_scene = wheat_plant_scene
		"Tomato":
			plant_scene = tomato_plant_scene
		_:
			print("Không hỗ trợ loại hạt giống: ", seed_type)
			return
	
	if plant_scene == null:
		print("Chưa gán scene cây cho ", seed_type)
		return
	
	var plant = plant_scene.instantiate()
	plant.position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	
	var plants_root = get_tree().current_scene.get_node("PlantsRoot")
	if plants_root:
		plants_root.add_child(plant)
	else:
		get_tree().current_scene.add_child(plant)
	
	print("Đã gieo ", seed_type, " tại ô ", cell_position, " (còn lại: ", plants_ui.seed_inventory[seed_type], ")")
	
	# Reset tool nếu hết hạt (tùy chọn)
	if plants_ui.seed_inventory[seed_type] <= 0:
		ToolManager.selecet_tool(DataTypes.Tools.None)

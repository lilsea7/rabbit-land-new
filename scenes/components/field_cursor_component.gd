#class_name FieldCursorComponent
#extends Node
#
#@export var grass_tilemap_layer: TileMapLayer
#@export var tilled_soil_tilemap_layer: TileMapLayer
#@export var terrain_set: int = 0
#@export var terrain: int = 3
#
## Export các scene cây
#@export var wheat_plant_scene: PackedScene
#@export var tomato_plant_scene: PackedScene
#@export var carrot_plant_scene: PackedScene
#@export var corn_plant_scene: PackedScene
#@export var rose_plant_scene: PackedScene
#@export var broccoli_plant_scene: PackedScene
#
#var player: Player
#var mouse_position: Vector2
#var cell_position: Vector2i
#var local_cell_position: Vector2
#var distance: float
#
#func _ready() -> void:
	#await get_tree().process_frame
	#player = get_tree().get_first_node_in_group("player")
	#if player == null:
		#push_error("Không tìm thấy Player trong group 'player'!")
#
	## Tự tìm TileMap nếu chưa gán
	#if not tilled_soil_tilemap_layer:
		#tilled_soil_tilemap_layer = get_tree().root.find_child("TilledSoil", true, false) as TileMapLayer
	#if not grass_tilemap_layer:
		#grass_tilemap_layer = get_tree().root.find_child("Grass", true, false) as TileMapLayer
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("remove_dirt"):
		#if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			#get_cell_under_mouse()
			#remove_tilled_soil_cell()
			#return
#
	#if event.is_action_pressed("hit"):
		#get_cell_under_mouse()
#
		#if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			#add_tilled_soil_cell()
			#return
#
		## ==================== TRỒNG CÂY ====================
		#var tool = ToolManager.selected_tool
		#if tool in [
			#DataTypes.Tools.PlantWheat,
			#DataTypes.Tools.PlantTomato,
			#DataTypes.Tools.PlantCarrot,
			#DataTypes.Tools.PlantCorn,
			#DataTypes.Tools.PlantRose,
			#DataTypes.Tools.PlantBroccoli
		#]:
			#if distance >= 20.0:
				#print("Quá xa để trồng!")
				#return
			#if not is_tilled_soil():
				#print("Ô này chưa được cày! Không thể trồng.")
				#return
			#
			#plant_seed()
			#return
#
#func get_cell_under_mouse() -> void:
	#if not tilled_soil_tilemap_layer:
		#return
	#mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	#cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	#local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	#distance = player.global_position.distance_to(local_cell_position)
#
#func add_tilled_soil_cell() -> void:
	#if distance < 20.0 and tilled_soil_tilemap_layer:
		#tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)
#
#func remove_tilled_soil_cell() -> void:
	#if distance < 20.0 and tilled_soil_tilemap_layer:
		#tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
#
#func is_tilled_soil() -> bool:
	#if not tilled_soil_tilemap_layer:
		#return false
	#var tile_data = tilled_soil_tilemap_layer.get_cell_tile_data(cell_position)
	#if tile_data != null and tile_data.get_terrain() == terrain:
		#return true
	#return false
#
## ====================== TRỒNG CÂY ======================
#func plant_seed() -> void:
	#var seed_type = ToolManager.current_seed_type
	#if seed_type == "":
		#print("Chưa chọn loại hạt giống!")
		#return
#
	#var plants_ui = get_tree().root.find_child("PlantsUI", true, false)
	#if plants_ui == null:
		#print("Không tìm thấy PlantsUI!")
		#return
#
	#if plants_ui.seed_inventory.get(seed_type, 0) <= 0:
		#print("Hết hạt giống ", seed_type, "!")
		#ToolManager.selecet_tool(DataTypes.Tools.None)
		#return
#
	## Trừ hạt giống
	#plants_ui.seed_inventory[seed_type] -= 1
	#plants_ui.update_quantity_label("Slot" + seed_type)
#
	## Chọn scene cây
	#var plant_scene: PackedScene = null
	#match seed_type:
		#"Wheat":    plant_scene = wheat_plant_scene
		#"Tomato":   plant_scene = tomato_plant_scene
		#"Carrot":   plant_scene = carrot_plant_scene
		#"Corn":     plant_scene = corn_plant_scene
		#"Rose":     plant_scene = rose_plant_scene
		#"Broccoli": plant_scene = broccoli_plant_scene
		#_:
			#print("Không hỗ trợ loại hạt giống: ", seed_type)
			#return
#
	#if plant_scene == null:
		#print("Chưa gán scene cây cho ", seed_type, "! Hãy gán trong Inspector.")
		#return
#
	## Gieo cây
	#var plant = plant_scene.instantiate()
	#plant.position = tilled_soil_tilemap_layer.map_to_local(cell_position)
#
	#var plants_root = get_tree().root.find_child("PlantsRoot", true, false)
	#if plants_root:
		#plants_root.add_child(plant)
	#else:
		#var current_scene = get_tree().current_scene
		#if current_scene:
			#current_scene.add_child(plant)
		#else:
			#get_tree().root.add_child(plant)
#
	#print("Đã gieo ", seed_type, " tại ô ", cell_position, " (còn lại: ", plants_ui.seed_inventory[seed_type], ")")
#
	## Cộng exp khi gieo
	#LevelManager.add_exp(LevelManager.exp_rewards["plant_seed"], "plant_seed")
class_name FieldCursorComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 3

# Export các scene cây
@export var wheat_plant_scene: PackedScene
@export var tomato_plant_scene: PackedScene
@export var carrot_plant_scene: PackedScene
@export var corn_plant_scene: PackedScene
@export var rose_plant_scene: PackedScene
@export var broccoli_plant_scene: PackedScene

var player: Player
var mouse_position: Vector2
var cell_position: Vector2i
var local_cell_position: Vector2
var distance: float

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_error("Không tìm thấy Player trong group 'player'!")
	
	# Tự tìm TileMap nếu chưa gán
	if not tilled_soil_tilemap_layer:
		tilled_soil_tilemap_layer = get_tree().root.find_child("TilledSoil", true, false) as TileMapLayer
	if not grass_tilemap_layer:
		grass_tilemap_layer = get_tree().root.find_child("Grass", true, false) as TileMapLayer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()
			return

	if event.is_action_pressed("hit"):
		get_cell_under_mouse()

		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			add_tilled_soil_cell()
			return

		# ==================== TRỒNG CÂY ====================
		var tool = ToolManager.selected_tool
		if tool in [
			DataTypes.Tools.PlantWheat, DataTypes.Tools.PlantTomato,
			DataTypes.Tools.PlantCarrot, DataTypes.Tools.PlantCorn,
			DataTypes.Tools.PlantRose, DataTypes.Tools.PlantBroccoli
		]:
			if distance >= 20.0:
				print("Quá xa để trồng!")
				return
			if not is_tilled_soil():
				print("Ô này chưa được cày! Không thể trồng.")
				return
			if is_occupied_by_plant():
				print("Ô này đã có cây trồng! Không thể trồng chồng.")
				return
			
			plant_seed()
			return

# ====================== CÁC HÀM CŨ ======================
func get_cell_under_mouse() -> void:
	if not tilled_soil_tilemap_layer:
		return
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)

func add_tilled_soil_cell() -> void:
	if distance < 20.0 and tilled_soil_tilemap_layer:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)

func remove_tilled_soil_cell() -> void:
	if distance < 20.0 and tilled_soil_tilemap_layer:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)

func is_tilled_soil() -> bool:
	if not tilled_soil_tilemap_layer:
		return false
	var tile_data = tilled_soil_tilemap_layer.get_cell_tile_data(cell_position)
	return tile_data != null and tile_data.get_terrain() == terrain

# ====================== HÀM MỚI: KIỂM TRA Ô ĐÃ CÓ CÂY CHƯA ======================
func is_occupied_by_plant() -> bool:
	var plants_root = get_tree().root.find_child("PlantsRoot", true, false)
	if not plants_root:
		return false
	
	for child in plants_root.get_children():
		if child is Node2D:
			# Chuyển vị trí global của cây sang cell position
			var plant_cell = tilled_soil_tilemap_layer.local_to_map(child.position)
			if plant_cell == cell_position:
				return true  # Ô này đã có cây
	
	return false

# ====================== TRỒNG CÂY ======================
func plant_seed() -> void:
	var seed_type = ToolManager.current_seed_type
	if seed_type == "":
		print("Chưa chọn loại hạt giống!")
		return

	var plants_ui = get_tree().root.find_child("PlantsUI", true, false)
	if plants_ui == null:
		print("Không tìm thấy PlantsUI!")
		return

	if plants_ui.seed_inventory.get(seed_type, 0) <= 0:
		print("Hết hạt giống ", seed_type, "!")
		ToolManager.selecet_tool(DataTypes.Tools.None)
		return

	# Trừ hạt giống
	plants_ui.seed_inventory[seed_type] -= 1
	plants_ui.update_quantity_label("Slot" + seed_type)

	# Chọn scene cây
	var plant_scene: PackedScene = null
	match seed_type:
		"Wheat":    plant_scene = wheat_plant_scene
		"Tomato":   plant_scene = tomato_plant_scene
		"Carrot":   plant_scene = carrot_plant_scene
		"Corn":     plant_scene = corn_plant_scene
		"Rose":     plant_scene = rose_plant_scene
		"Broccoli": plant_scene = broccoli_plant_scene
		_:
			print("Không hỗ trợ loại hạt giống: ", seed_type)
			return

	if plant_scene == null:
		print("Chưa gán scene cây cho ", seed_type)
		return

	# Gieo cây
	var plant = plant_scene.instantiate()
	plant.position = tilled_soil_tilemap_layer.map_to_local(cell_position)

	var plants_root = get_tree().root.find_child("PlantsRoot", true, false)
	if plants_root:
		plants_root.add_child(plant)
	else:
		get_tree().current_scene.add_child(plant)

	print("Đã gieo ", seed_type, " tại ô ", cell_position, " (còn lại: ", plants_ui.seed_inventory[seed_type], ")")

	# Cộng exp khi gieo
	LevelManager.add_exp(LevelManager.exp_rewards["plant_seed"], "plant_seed")

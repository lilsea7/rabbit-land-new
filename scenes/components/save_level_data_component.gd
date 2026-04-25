class_name SaveLevelDataComponent
extends Node

var save_game_data_path: String = "user://game_data/"
var save_file_name: String = "save_game_data.tres"
var game_data_resource: SaveGameDataResource

# Lưu tạm vị trí đá bị chặt trong session hiện tại
var removed_positions: Array = []
var removed_small_trees: Array = []
var removed_large_trees: Array = []

func _ready() -> void:
	add_to_group("save_level_data_component")
	# Khởi tạo resource ngay từ đầu để mark_object_as_removed() hoạt động
	game_data_resource = SaveGameDataResource.new()

# ====================== SAVE GAME ======================
func save_game() -> void:
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)
	
	game_data_resource = SaveGameDataResource.new()
	
	save_level_and_exp()
	save_inventory()
	save_plants()
	save_harvests()
	save_tilled_tiles()
	save_removed_objects()
	save_removed_trees() 
	save_tools()
	save_time()
	
	var path = save_game_data_path + save_file_name
	var result = ResourceSaver.save(game_data_resource, path)
	
	if result == OK:
		print("✅ Game đã lưu thành công! File: ", path)
	else:
		push_error("❌ Lưu game thất bại! Code: ", result)

# ====================== LOAD GAME ======================
func load_game() -> void:
	var path = save_game_data_path + save_file_name
	if not FileAccess.file_exists(path):
		print("Không tìm thấy file save!")
		return
	
	game_data_resource = ResourceLoader.load(path)
	if not game_data_resource:
		push_error("❌ Không load được file save!")
		return
	
	print("📂 Đã load file save thành công.")

	load_level_and_exp()
	load_inventory()
	load_plants()
	load_harvests()
	load_tilled_tiles()
	load_removed_objects()
	load_removed_trees()
	load_tools()
	load_time()
	
	# Khôi phục removed_positions từ file save
	if game_data_resource.removed_objects:
		removed_positions = game_data_resource.removed_objects.duplicate()
	
	print("✅ Game đã load thành công!")

# ================== LEVEL + EXP ==================
func save_level_and_exp() -> void:
	if LevelManager and game_data_resource:
		game_data_resource.level = LevelManager.current_level
		game_data_resource.exp = LevelManager.current_exp

func load_level_and_exp() -> void:
	if LevelManager and game_data_resource:
		LevelManager.current_level = game_data_resource.level
		LevelManager.current_exp = game_data_resource.exp
		call_deferred("_emit_level_signals")

func _emit_level_signals() -> void:
	LevelManager.exp_changed.emit(
		LevelManager.current_exp,
		LevelManager.get_exp_to_next_level()
	)
	LevelManager.level_up.emit(LevelManager.current_level)
	print("✅ Đã load level: ", LevelManager.current_level, " | exp: ", LevelManager.current_exp)
	
# ================== TOOLS ==================
func save_tools() -> void:
	if not game_data_resource: return
	# Chuyển key từ enum sang int để lưu được
	var tools_data = {}
	for tool in ToolManager.unlocked_tools.keys():
		tools_data[int(tool)] = ToolManager.unlocked_tools[tool]
	game_data_resource.unlocked_tools = tools_data
	print("💾 Đã lưu trạng thái tools")

func load_tools() -> void:
	if not game_data_resource or game_data_resource.unlocked_tools.is_empty():
		print("ℹ️ Không có dữ liệu tools.")
		return
	for tool_int in game_data_resource.unlocked_tools.keys():
		var tool = tool_int as DataTypes.Tools
		if game_data_resource.unlocked_tools[tool_int]:
			ToolManager.unlock_tool(tool)
	print("✅ Đã load trạng thái tools")
	
# ================== INVENTORY ==================
func save_inventory() -> void:
	if InventoryManager and game_data_resource:
		game_data_resource.inventory = InventoryManager.inventory.duplicate()

func load_inventory() -> void:
	if InventoryManager and game_data_resource and game_data_resource.inventory:
		InventoryManager.inventory = game_data_resource.inventory.duplicate()
		InventoryManager.inventory_changed.emit()
		

# ================== THỜI GIAN ==================
func save_time() -> void:
	if not game_data_resource: return
	game_data_resource.game_time = DayAndNightCycleManager.time
	print("💾 Đã lưu thời gian: ", DayAndNightCycleManager.time)

func load_time() -> void:
	if not game_data_resource: return
	DayAndNightCycleManager.time = game_data_resource.game_time
	print("✅ Đã load thời gian: ", DayAndNightCycleManager.time)

# ================== CÂY TRỒNG ==================
#func save_plants() -> void:
	#if not game_data_resource: return
	#var plants_root = get_tree().root.find_child("PlantsRoot", true, false)
	#if not plants_root: return
	#game_data_resource.plants_data.clear()
	#for plant in plants_root.get_children():
		#if plant.has_method("get_save_data"):
			#var data = plant.get_save_data()
			#if data:
				#game_data_resource.plants_data.append(data)
#
#func load_plants() -> void:
	#var plants_root = get_tree().root.find_child("PlantsRoot", true, false)
	#if not plants_root or not game_data_resource: return
	#for child in plants_root.get_children():
		#child.queue_free()
	#for data in game_data_resource.plants_data:
		#if data.has("scene_path"):
			#var scene = load(data["scene_path"])
			#if scene:
				#var plant = scene.instantiate()
				#plant.position = data["position"]
				#if plant.has_method("load_save_data") and data.has("extra_data"):
					#plant.load_save_data(data["extra_data"])
				#plants_root.add_child(plant)

func save_plants() -> void:
	if not game_data_resource: return
	var plants_root = get_tree().root.find_child("PlantsRoot", true, false)
	if not plants_root: return
	game_data_resource.plants_data.clear()
	for plant in plants_root.get_children():
		if plant.has_method("get_save_data"):
			var data = plant.get_save_data()
			if data:
				game_data_resource.plants_data.append(data)
	print("💾 Đã lưu ", game_data_resource.plants_data.size(), " cây trồng")

func load_plants() -> void:
	var plants_root = get_tree().root.find_child("PlantsRoot", true, false)
	if not plants_root or not game_data_resource: return
	# Xóa cây cũ
	for child in plants_root.get_children():
		child.queue_free()
	await get_tree().process_frame
	for data in game_data_resource.plants_data:
		if not data.has("scene_path"):
			continue
		var scene = load(data["scene_path"])
		if not scene:
			continue
		var plant = scene.instantiate()
		plants_root.add_child(plant)
		# Gọi load_save_data với toàn bộ data thay vì data["extra_data"]
		if plant.has_method("load_save_data"):
			plant.load_save_data(data)
	print("✅ Đã load ", game_data_resource.plants_data.size(), " cây trồng")

# ================== SẢN PHẨM TỪ CÂY TRỒNG ==================
func save_harvests() -> void:
	if not game_data_resource: return
	# Harvest items nằm ở HarvestRoot hoặc cùng parent với cây
	var harvests = get_tree().get_nodes_in_group("harvest_item")
	game_data_resource.harvests_data.clear()
	for harvest in harvests:
		if harvest.has_method("get_save_data"):
			game_data_resource.harvests_data.append(harvest.get_save_data())
		else:
			# Lưu tối thiểu scene_path và position
			game_data_resource.harvests_data.append({
				"scene_path": harvest.scene_file_path,
				"position": harvest.global_position
			})
	print("💾 Đã lưu ", game_data_resource.harvests_data.size(), " harvest items")

func load_harvests() -> void:
	if not game_data_resource or game_data_resource.harvests_data.is_empty():
		return
	var plants_root = get_tree().root.find_child("PlantsRoot", true, false)
	if not plants_root: return
	await get_tree().process_frame
	for data in game_data_resource.harvests_data:
		if not data.has("scene_path"):
			continue
		var scene = load(data["scene_path"])
		if not scene:
			continue
		var harvest = scene.instantiate()
		harvest.global_position = data["position"]
		plants_root.add_child(harvest)
	print("✅ Đã load ", game_data_resource.harvests_data.size(), " harvest items")

# ================== Ô ĐẤT ĐÃ CUỐC ==================
func save_tilled_tiles() -> void:
	if not game_data_resource: return
	var tilled_layer = get_tree().root.find_child("TilledSoil", true, false) as TileMapLayer
	if not tilled_layer:
		print("⚠️ Không tìm thấy TilledSoil!")
		return
	
	var cells_data = []
	for cell in tilled_layer.get_used_cells():
		cells_data.append({"x": cell.x, "y": cell.y})
	
	game_data_resource.tilled_tiles = cells_data
	print("💾 Đã lưu ", cells_data.size(), " ô đất đã cuốc")

func load_tilled_tiles() -> void:
	if not game_data_resource or game_data_resource.tilled_tiles.is_empty():
		print("ℹ️ Không có ô đất nào đã cuốc.")
		return
	call_deferred("_do_load_tilled_tiles")

func _do_load_tilled_tiles() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

	var tilled_layer = get_tree().root.find_child("TilledSoil", true, false) as TileMapLayer
	if not tilled_layer:
		print("⚠️ Không tìm thấy TilledSoil!")
		return

	var cells = []
	for cell_data in game_data_resource.tilled_tiles:
		cells.append(Vector2i(cell_data["x"], cell_data["y"]))

	tilled_layer.set_cells_terrain_connect(cells, 0, 3, true)
	print("✅ Đã load ", cells.size(), " ô đất đã cuốc")

# ================== ROCK ==================
func save_removed_objects() -> void:
	if not game_data_resource: return
	# Lưu từ removed_positions thay vì tìm node đã bị queue_free
	game_data_resource.removed_objects = removed_positions.duplicate()
	#print("💾 Đã lưu ", removed_positions.size(), " vị trí đá bị chặt")

func load_removed_objects() -> void:
	if not game_data_resource or game_data_resource.removed_objects.is_empty():
		print("ℹ️ Không có vật nào bị chặt trước đó.")
		return
	call_deferred("_do_remove_rocks") 

func _do_remove_rocks() -> void: 
	await get_tree().process_frame
	await get_tree().process_frame

	var rocks = get_tree().get_nodes_in_group("rock")
	#print("🪨 Số rock tìm thấy: ", rocks.size())

	var removed_count = 0
	for rock in rocks:
		if not is_instance_valid(rock): continue
		for pos in game_data_resource.removed_objects:
			if rock.global_position.distance_to(pos) < 5.0:
				rock.visible = false
				rock.queue_free()
				removed_count += 1
				break

	print("✅ Đã xóa ", removed_count, " rock khi load game.")
	

# Hàm được gọi từ rock khi bị chặt
func mark_object_as_removed(position: Vector2) -> void:
	if not removed_positions.has(position):
		removed_positions.append(position)
		#print("📌 Đã đánh dấu đá bị chặt tại vị trí: ", position)
		
# ================== SMALL TREE ==================
func mark_tree_as_removed(position: Vector2, tree_type: String) -> void:
	if tree_type == "small":
		if not removed_small_trees.has(position):
			removed_small_trees.append(position)
			#print("📌 Small tree bị chặt tại: ", position)
	elif tree_type == "large":
		if not removed_large_trees.has(position):
			removed_large_trees.append(position)
			#print("📌 Large tree bị chặt tại: ", position)

func save_removed_trees() -> void:
	if not game_data_resource: return
	game_data_resource.removed_small_trees = removed_small_trees.duplicate()
	game_data_resource.removed_large_trees = removed_large_trees.duplicate()
	#print("💾 Đã lưu ", removed_small_trees.size(), " small tree và ", removed_large_trees.size(), " large tree bị chặt")

func load_removed_trees() -> void:
	if not game_data_resource: return
	if game_data_resource.removed_small_trees:
		removed_small_trees = game_data_resource.removed_small_trees.duplicate()
	if game_data_resource.removed_large_trees:
		removed_large_trees = game_data_resource.removed_large_trees.duplicate()
	call_deferred("_do_remove_trees")

func _do_remove_trees() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

	# Xóa small trees
	var small_trees = get_tree().get_nodes_in_group("small_tree")
	#print("🌲 Số small tree tìm thấy: ", small_trees.size())
	for tree in small_trees:
		if not is_instance_valid(tree): continue
		for pos in game_data_resource.removed_small_trees:
			if tree.global_position.distance_to(pos) < 5.0:
				#print("🗑️ Xóa small tree tại: ", tree.global_position)
				tree.queue_free()
				break

	# Xóa large trees
	var large_trees = get_tree().get_nodes_in_group("large_tree")
	#print("🌳 Số large tree tìm thấy: ", large_trees.size())
	for tree in large_trees:
		if not is_instance_valid(tree): continue
		for pos in game_data_resource.removed_large_trees:
			if tree.global_position.distance_to(pos) < 5.0:
				#print("🗑️ Xóa large tree tại: ", tree.global_position)
				tree.queue_free()
				break

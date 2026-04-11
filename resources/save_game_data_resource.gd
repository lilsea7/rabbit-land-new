#class_name SaveGameDataResource
#extends Resource
#
#@export var save_data_nodes: Array[NodeDataResource]

@tool
class_name SaveGameDataResource
extends Resource

# ================== DỮ LIỆU NGƯỜI CHƠI ==================
@export var level: int = 1
@export var exp: int = 0
@export var coin: int = 50

# ================== INVENTORY ==================
@export var inventory: Dictionary = {}

# ================== CÂY TRỒNG ==================
@export var plants_data: Array = []

# ================== Ô ĐẤT ĐÃ CUỐC ==================
@export var tilled_tiles: Array = []

# ================== OBJECT ĐÃ BỊ CHẶT ==================
@export var removed_objects: Array = []   
@export var removed_small_trees: Array = []
@export var removed_large_trees: Array = []

# ================== TOOLS ==================
@export var unlocked_tools: Dictionary = {}

# ================== TIMES ==================
@export var game_time: float = 0.0
func _init():
	if inventory == null:
		inventory = {}
	if plants_data == null:
		plants_data = []
	if tilled_tiles == null:
		tilled_tiles = []
	if removed_objects == null:
		removed_objects = []

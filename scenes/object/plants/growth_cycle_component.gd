#class_name GrowthCycleComponent
#extends Node
#
#@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
#@export_range(5, 365) var days_until_harvest: int = 7
#
#signal crop_maturity
#signal crop_harvesting
#
#var is_watered: bool = false
#var starting_day: int = 0
#var current_day: int = 0
#
## Biến kiểm soát để chỉ emit một lần
#var has_emitted_maturity: bool = false
#var has_emitted_harvesting: bool = false
#
#func _ready() -> void:
	#DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)
#
#func on_time_tick_day(day: int) -> void:
	#current_day = day
	#if is_watered and starting_day == 0:
		#starting_day = day
	#
	#growth_states(starting_day, current_day)
	#harvest_state(starting_day, current_day)
#
#func growth_states(starting_day: int, current_day: int) -> void:
	#if current_growth_state == DataTypes.GrowthStates.Maturity or has_emitted_maturity:
		#return
	#
	#var num_states = 5
	#var growth_days_passed = (current_day - starting_day) % num_states
	#var state_index = growth_days_passed % num_states + 1
	#
	#current_growth_state = state_index as DataTypes.GrowthStates
	#
	#if current_growth_state == DataTypes.GrowthStates.Maturity:
		#print("🌱 Cây đã đạt Maturity!")
		#crop_maturity.emit()
		#has_emitted_maturity = true   # ← Chỉ emit một lần
#
#func harvest_state(starting_day: int, current_day: int) -> void:
	#if current_growth_state == DataTypes.GrowthStates.Harvesting or has_emitted_harvesting:
		#return
	#
	#var days_passed = (current_day - starting_day) % days_until_harvest
	#
	#if days_passed == days_until_harvest - 1:
		#current_growth_state = DataTypes.GrowthStates.Harvesting
		#print("🌾 Cây sẵn sàng thu hoạch!")
		#crop_harvesting.emit()
		#has_emitted_harvesting = true   # ← Chỉ emit một lần
#
#func get_current_growth_state() -> DataTypes.GrowthStates:
	#return current_growth_state
class_name GrowthCycleComponent
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 7

signal crop_maturity
signal crop_harvesting

var is_watered: bool = false
var starting_day: int = 0
var current_day: int = 0

# Biến kiểm soát để chỉ emit một lần
var has_emitted_maturity: bool = false
var has_emitted_harvesting: bool = false

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	current_day = day
	if is_watered and starting_day == 0:
		starting_day = day
	
	growth_states(starting_day, current_day)
	harvest_state(starting_day, current_day)

func growth_states(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Maturity or has_emitted_maturity:
		return
	
	var num_states = 5
	var growth_days_passed = (current_day - starting_day) % num_states
	var state_index = growth_days_passed % num_states + 1
	
	current_growth_state = state_index as DataTypes.GrowthStates
	
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		print("🌱 Cây đã đạt Maturity!")
		crop_maturity.emit()
		has_emitted_maturity = true

# ================== THU HOẠCH - CHỈ CỘNG EXP Ở ĐÂY ==================
func harvest_state(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Harvesting or has_emitted_harvesting:
		return
	
	var days_passed = (current_day - starting_day) % days_until_harvest
	
	if days_passed == days_until_harvest - 1:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		print("🌾 Cây sẵn sàng thu hoạch!")
		crop_harvesting.emit()
		has_emitted_harvesting = true
		
		# === THÊM EXP KHI CÂY ĐẠT TRẠNG THÁI HARVESTING (SẴN SÀNG THU HOẠCH) ===
		LevelManager.add_exp(LevelManager.exp_rewards["harvest_crop"], "harvest_crop")

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state

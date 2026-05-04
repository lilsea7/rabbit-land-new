# plant_base.gd
class_name PlantBase
extends Node2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

func get_save_data() -> Dictionary:
	return {
		"scene_path": scene_file_path,
		"position": global_position,
		"growth_state": growth_state,
		"is_watered": growth_cycle_component.is_watered,
		"starting_day": growth_cycle_component.starting_day,
		"has_emitted_maturity": growth_cycle_component.has_emitted_maturity,
		"has_emitted_harvesting": growth_cycle_component.has_emitted_harvesting,
	}

func load_save_data(data: Dictionary) -> void:
	if data.has("position"):
		global_position = data["position"]
	if data.has("growth_state") and growth_cycle_component:
		growth_state = data["growth_state"] as DataTypes.GrowthStates
		growth_cycle_component.current_growth_state = growth_state
	if data.has("is_watered") and growth_cycle_component:
		growth_cycle_component.is_watered = data["is_watered"]
	if data.has("starting_day") and growth_cycle_component:
		growth_cycle_component.starting_day = data["starting_day"]
	if data.has("has_emitted_maturity") and growth_cycle_component:
		growth_cycle_component.has_emitted_maturity = data["has_emitted_maturity"]
	if data.has("has_emitted_harvesting") and growth_cycle_component:
		growth_cycle_component.has_emitted_harvesting = data["has_emitted_harvesting"]
	if sprite_2d:
		sprite_2d.frame = growth_state

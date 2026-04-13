extends Node2D

# ================== CONFIG ==================
const HARVEST_DAYS: int = 4
const EXP_PLANT: int = 6
const EXP_HARVEST: int = 7

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent
var corn_harvest_scene = preload("res://scenes/object/plants/corn_harvest.tscn")
var has_harvested: bool = false
@onready var save_data_component: SaveDataComponent = $SaveDataComponent

func _ready() -> void:
	growth_cycle_component.days_until_harvest = HARVEST_DAYS

	watering_particles.emitting = false
	flowering_particles.emitting = false

	if hurt_component:
		hurt_component.hurt.connect(on_hurt)
	if growth_cycle_component:
		growth_cycle_component.crop_maturity.connect(on_crop_maturity)
		growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)
		growth_cycle_component.crop_ready_harvest.connect(on_crop_ready_harvest)

	if animated_sprite:
		animated_sprite.frame = 0

	if save_data_component:
		save_data_component.save_data_resource = PlantSaveDataResource.new()


func _process(delta: float) -> void:
	if growth_cycle_component and animated_sprite:
		var current_state = growth_cycle_component.get_current_growth_state()
		animated_sprite.frame = current_state
		if current_state == DataTypes.GrowthStates.Maturity:
			flowering_particles.emitting = true
		else:
			flowering_particles.emitting = false

func on_hurt(hit_damage: int) -> void:
	if growth_cycle_component and not growth_cycle_component.is_watered:
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_watered = true

func on_crop_maturity() -> void:
	flowering_particles.emitting = true

func on_crop_harvesting() -> void:
	if has_harvested:
		return
	has_harvested = true
	if corn_harvest_scene:
		var harvest_instance = corn_harvest_scene.instantiate() as Node2D
		if harvest_instance:
			harvest_instance.global_position = global_position
			get_parent().add_child(harvest_instance)
	queue_free()

func on_crop_ready_harvest() -> void:
	LevelManager.add_exp(EXP_HARVEST, "harvest_crop")

# ================== SAVE & LOAD ==================
func get_save_data() -> Dictionary:
	return {
		"scene_path": scene_file_path,
		"position": global_position,
		"growth_state": growth_cycle_component.get_current_growth_state(),
		"is_watered": growth_cycle_component.is_watered
	}

func load_save_data(data: Dictionary) -> void:
	if data.has("position"):
		global_position = data["position"]
	if data.has("growth_state") and growth_cycle_component:
		growth_cycle_component.current_growth_state = data["growth_state"] as DataTypes.GrowthStates
	if data.has("is_watered") and growth_cycle_component:
		growth_cycle_component.is_watered = data["is_watered"]
	if animated_sprite and growth_cycle_component:
		animated_sprite.frame = growth_cycle_component.get_current_growth_state()

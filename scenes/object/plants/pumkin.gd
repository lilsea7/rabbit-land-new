extends Node2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var pumkin_harvest_scene = preload("res://scenes/object/plants/pumkin_harvest.tscn")

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	if hurt_component:
		hurt_component.hurt.connect(on_hurt)
	if growth_cycle_component:
		growth_cycle_component.crop_maturity.connect(on_crop_maturity)
		growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)
	
	# Đặt frame ban đầu là Seed
	if animated_sprite:
		animated_sprite.frame = 0

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
	if pumkin_harvest_scene:
		var harvest_instance = pumkin_harvest_scene.instantiate() as Node2D
		if harvest_instance:
			harvest_instance.global_position = global_position
			get_parent().add_child(harvest_instance)
	
	queue_free()

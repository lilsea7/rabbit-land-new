# door_exit.gd
extends StaticBody2D

# door ra ngoài
@export var target_scene: String = "res://scenes/levels/level_1.tscn"
@export var spawn_point_name: String = "FarmSpawnPoint"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent

var is_transitioning: bool = false

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	collision_layer = DataTypes.ColisonLayer.Ground

func on_interactable_activated() -> void:
	if is_transitioning:
		return
	is_transitioning = true

	animated_sprite_2d.play("open_door")
	collision_layer = DataTypes.ColisonLayer.Player
	await get_tree().create_timer(0.5).timeout
	SceneTransition.fade_to_scene(target_scene, spawn_point_name)

func on_interactable_deactivated() -> void:
	animated_sprite_2d.play("close_door")
	collision_layer = DataTypes.ColisonLayer.Ground

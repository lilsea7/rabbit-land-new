extends StaticBody2D

@export var target_scene: String = "res://scenes/houses/in_small_house.tscn"
@export var spawn_point_name: String = "SpawnPoint"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent

var is_transitioning: bool = false  # ← Flag chặn gọi nhiều lần

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
	SaveGameManager.save_game()
	await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(0.5).timeout
	SceneTransition.fade_to_scene(target_scene, spawn_point_name)
# Save state trước khi chuyển scene
	SceneTransition.fade_to_scene(target_scene, spawn_point_name)

func on_interactable_deactivated() -> void:
	animated_sprite_2d.play("close_door")
	collision_layer = DataTypes.ColisonLayer.Ground

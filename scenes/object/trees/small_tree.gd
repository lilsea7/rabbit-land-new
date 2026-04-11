extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scenes/object/trees/log.tscn")

func _ready() -> void:
	add_to_group("small_tree")  # ← Thêm vào group
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 0.5)
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damage_reached() -> void:
	await get_tree().create_timer(0.5).timeout

	# Đánh dấu cây bị chặt
	var save_component = get_tree().get_first_node_in_group("save_level_data_component")
	if save_component and save_component.has_method("mark_tree_as_removed"):
		save_component.mark_tree_as_removed(global_position, "small")
		print("📌 Đã đánh dấu small tree bị chặt tại: ", global_position)

	add_log_scene()
	print("max reached")
	queue_free()

func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)

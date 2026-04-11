extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var stone_scene = preload("res://scenes/object/rocks/stone.tscn")

func _ready() -> void:
	add_to_group("rock")  # ← Thêm dòng này
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 0.3)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damage_reached() -> void:
	await get_tree().create_timer(0.3).timeout
	
	# Đánh dấu đá bị chặt
	set_meta("destroyed", true)
	
	var save_component = get_tree().get_first_node_in_group("save_level_data_component")
	if save_component and save_component.has_method("mark_object_as_removed"):
		save_component.mark_object_as_removed(global_position)
		print("📌 Đã đánh dấu đá bị chặt tại vị trí: ", global_position)
	
	add_stone_scene()
	queue_free()

func add_stone_scene() -> void:
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)

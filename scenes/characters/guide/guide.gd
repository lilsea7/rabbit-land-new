extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool = false

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	
	# Kết nối signal từ dialogue (nếu bạn vẫn dùng)
	GameDialogueManager.give_crops_seeds.connect(on_give_crop_seeds)

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("show_dialogue"):
		var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
		get_tree().root.add_child(balloon)
		balloon.start(load("res://dialogue/conversations/guide.dialogue"), "start")

# ================== NHẬN BỘ DỤNG CỤ KHỞI ĐẦU TỪ NPC ==================
func on_give_crop_seeds() -> void:
	print("🎁 NPC tặng bộ dụng cụ khởi đầu cho người chơi!")
	
	# Mở khóa 3 tool cơ bản
	ToolManager.unlock_tool(DataTypes.Tools.AxeWood)
	ToolManager.unlock_tool(DataTypes.Tools.TillGround)
	ToolManager.unlock_tool(DataTypes.Tools.WaterCrops)
	
	# Tặng thêm một ít hạt giống ban đầu (tùy chọn, bạn có thể chỉnh số lượng)
	#if InventoryManager:
		#InventoryManager.add_collectable("wheat", 5)
		#InventoryManager.add_collectable("tomato", 3)
		#print("🌱 Đã tặng 5 hạt lúa mì và 3 hạt cà chua")
	
	print("✅ Người chơi đã nhận rìu, cuốc, bình tưới!")

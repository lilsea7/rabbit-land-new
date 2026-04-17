extends CanvasLayer

@onready var background: ColorRect = $Background
@onready var story_label: Label = $Background/StoryLabel

var stories = [
	"Một hạt giống nhỏ...",
	"Một ước mơ lớn...",
	"Hành trình xây dựng nông trại của chú thỏ nhỏ bắt đầu!"
]

func _ready() -> void:
	background.modulate.a = 0.0
	story_label.modulate.a = 0.0
	story_label.text = ""
	_start_intro()

func _start_intro() -> void:
	var tween = create_tween()
	tween.tween_property(background, "modulate:a", 1.0, 0.5)
	await tween.finished

	for story in stories:
		story_label.text = story
		
		var t_in = create_tween()
		t_in.tween_property(story_label, "modulate:a", 1.0, 0.8)
		await t_in.finished
		
		# Giữ 1.5 giây
		await get_tree().create_timer(1.5).timeout
		
		# Fade out chữ
		var t_out = create_tween()
		t_out.tween_property(story_label, "modulate:a", 0.0, 0.5)
		await t_out.finished

	# Fade out toàn bộ rồi chuyển sang game
	var fade_out = create_tween()
	fade_out.tween_property(background, "modulate:a", 0.0, 1.0)
	await fade_out.finished

	_go_to_game()

func _go_to_game() -> void:
	queue_free()
	GameManager._load_main_game()

# Cho phép skip bằng cách bấm bất kỳ phím nào
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton:
		_go_to_game()

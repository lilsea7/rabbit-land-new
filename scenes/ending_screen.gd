extends CanvasLayer

@onready var background: ColorRect = $Background
@onready var story_label: Label = $Background/StoryLabel
@onready var credit_container: VBoxContainer = $Background/CreditContainer
@onready var final_label: Label = $Background/FinalLabel

var stories = [
	"Cảm ơn bạn vì đã ở đây... ",
	"Từ những ngày đầu chỉ là một mảnh đất hoang sơ,\nbạn đã cùng chú thỏ nhỏ tạo nên một nông trại đầy sức sống.",
	"Từng hạt giống, từng mùa vụ…\nđều mang theo sự kiên nhẫn và niềm vui giản dị.",
	
]

var credits = [
	"Rabbitland",
	"",
	"Developed by Nguyen Phuong Thao",
	"",
	"Game Design",
	"Nguyen Phuong Thao",
	"",
	"Programming",
	"Nguyen Phuong Thao",
	"",
	"Art & Animation",
	"Cup Nooble",
	"",
	"Special Thanks",
	"All players who joined this journey 💚",
	"",
]

func _ready() -> void:
	background.modulate.a = 0.0
	story_label.modulate.a = 0.0
	story_label.text = ""
	credit_container.modulate.a = 0.0
	final_label.modulate.a = 0.0
	_start_ending()

func _start_ending() -> void:
	# Fade in background
	var tween = create_tween()
	tween.tween_property(background, "modulate:a", 1.0, 1.0)
	await tween.finished

	# Hiển thị từng câu story
	for story in stories:
		story_label.text = story

		var t_in = create_tween()
		t_in.tween_property(story_label, "modulate:a", 1.0, 1.0)
		await t_in.finished

		await get_tree().create_timer(2.5).timeout

		var t_out = create_tween()
		t_out.tween_property(story_label, "modulate:a", 0.0, 0.8)
		await t_out.finished

	story_label.visible = false

	# Tạo credit labels
	var pixel_font = preload("res://assets/ui/fonts/pixelFont-7-8x14-sproutLands.ttf")

# Trong vòng lặp tạo credit labels
	for credit_text in credits:
		var label = Label.new()
		label.text = credit_text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_override("font", pixel_font)  # ← Thêm dòng này
	
		if credit_text == "Rabbitland":
			label.add_theme_font_size_override("font_size", 48)
			label.add_theme_color_override("font_color", Color.YELLOW)
		elif credit_text == "A Farming Journey":
			label.add_theme_font_size_override("font_size", 24)
			label.add_theme_color_override("font_color", Color.WHITE)
		elif credit_text in ["Game Design", "Programming", "Art & Animation", "Special Thanks", "Developed by [Tên bạn / team]"]:
			label.add_theme_font_size_override("font_size", 18)
			label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
		else:
			label.add_theme_font_size_override("font_size", 16)
			label.add_theme_color_override("font_color", Color.WHITE)
		credit_container.add_child(label)

	# Chờ layout xong
	await get_tree().process_frame

	# Đặt credit bắt đầu từ dưới màn hình
	credit_container.position.y = get_viewport().size.y + 100

	# Fade in credit container
	var c_in = create_tween()
	c_in.tween_property(credit_container, "modulate:a", 1.0, 0.5)
	await c_in.finished

	# Scroll credit từ dưới lên
	var scroll_height = credit_container.get_child_count() * 40 + get_viewport().size.y
	var scroll_tween = create_tween()
	scroll_tween.tween_property(
		credit_container,
		"position:y",
		-scroll_height,
		scroll_height / 80.0  # Tốc độ scroll
	).set_ease(Tween.EASE_IN_OUT)
	await scroll_tween.finished

	# Hiển thị câu kết
	final_label.text = "Cảm ơn bạn đã đồng hành.\nVà hành trình của chúng ta vẫn chưa kết thúc."
	var f_in = create_tween()
	f_in.tween_property(final_label, "modulate:a", 1.0, 1.5)
	await f_in.finished

	await get_tree().create_timer(3.0).timeout

	# Fade out rồi tiếp tục chơi
	var fade_out = create_tween()
	fade_out.set_parallel(true)
	fade_out.tween_property(background, "modulate:a", 0.0, 1.5)
	fade_out.tween_property(final_label, "modulate:a", 0.0, 1.5)
	await fade_out.finished

	queue_free()

# Skip bằng Enter
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		queue_free()

# sound_manager.gd
extends Node

# ================== NHẠC NỀN ==================
@onready var bgm_player: AudioStreamPlayer = $BGM/OnTheFarmMusic

# ================== SFX GÀ ==================
@onready var chicken_sfx_1: AudioStreamPlayer2D = $SFX/ChickenCluck1SFX
@onready var chicken_sfx_2: AudioStreamPlayer2D = $SFX/ChickenCluck2SFX
@onready var chicken_sfx_3: AudioStreamPlayer2D = $SFX/ChickenCluck3SFX
@onready var chicken_sfx_multiple: AudioStreamPlayer2D = $SFX/ChickenCluckMultipleSFX

# ================== SFX BÒ ==================
@onready var cow_sfx: AudioStreamPlayer2D = $SFX/CowMooSFX

# ================== SFX BUTTON ==================
@onready var button_click_sfx: AudioStreamPlayer = $SFX/ButtonClick

# ================== HURT TREE ROCK ==================
@onready var hurt_sfx: AudioStreamPlayer2D = $SFX/HurtSfx

# ================== CÀI ĐẶT ==================
@export var bgm_volume: float = 0.5
@export var sfx_volume: float = 1.0

var chicken_sfx_list: Array = []

func _ready() -> void:
	chicken_sfx_list = [chicken_sfx_1, chicken_sfx_2, chicken_sfx_3, chicken_sfx_multiple]
	set_bgm_volume(bgm_volume)
	set_sfx_volume(sfx_volume)
	play_bgm()

# ================== NHẠC NỀN ==================
func play_bgm() -> void:
	if bgm_player and not bgm_player.playing:
		#bgm_player.play()
		print("🎵 Đang phát nhạc nền")

func stop_bgm() -> void:
	if bgm_player:
		bgm_player.stop()

func set_bgm_volume(value: float) -> void:
	if bgm_player:
		bgm_player.volume_db = linear_to_db(value)

# ================== SFX GÀ ==================
func play_chicken_sfx(position: Vector2) -> void:
	var sfx = chicken_sfx_list[randi() % chicken_sfx_list.size()]
	if sfx == null:
		print("⚠️ Chicken SFX null!")
		return
	if not sfx.playing:
		sfx.global_position = position
		sfx.play()

# ================== SFX BÒ ==================
func play_cow_sfx(position: Vector2) -> void:
	if cow_sfx == null:
		print("⚠️ Cow SFX null!")
		return
	if not cow_sfx.playing:
		cow_sfx.global_position = position
		cow_sfx.play()

# ================== ÂM LƯỢNG SFX ==================
func set_sfx_volume(value: float) -> void:
	for sfx in chicken_sfx_list:
		if sfx:
			sfx.volume_db = linear_to_db(value)
	for sfx in [cow_sfx, button_click_sfx, hurt_sfx]:
		if sfx:
			sfx.volume_db = linear_to_db(value)

# ================== SFX UI ==================
func play_button_click() -> void:
	if button_click_sfx and not button_click_sfx.playing:
		button_click_sfx.play()

# ================== SFX CHẶT CÂY / ĐÁ ==================
func play_hurt_sfx(position: Vector2) -> void:
	if hurt_sfx == null:
		print("⚠️ Hurt SFX null!")
		return
	hurt_sfx.global_position = position
	hurt_sfx.play()

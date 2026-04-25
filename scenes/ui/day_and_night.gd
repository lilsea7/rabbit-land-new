extends Control

# ==================== THAM CHIẾU NODES ====================
@onready var main_icon_container: TextureRect = $TextureRect/TextureRectIcon
# Các icon con
@onready var icon_morning: TextureRect = $TextureRect/TextureRectIcon/icon_morning
@onready var icon_noon: TextureRect = $TextureRect/TextureRectIcon/icon_noon
@onready var icon_afternoon: TextureRect = $TextureRect/TextureRectIcon/icon_afternoon
@onready var icon_sunset: TextureRect = $TextureRect/TextureRectIcon/icon_sunset
@onready var icon_evening: TextureRect = $TextureRect/TextureRectIcon/icon_evening
@onready var icon_night: TextureRect = $TextureRect/TextureRectIcon/icon_night

# DayLabel
@onready var day_label: Label = $TextureRect/MarginContainer/DayLabel

# ==================== THÊM MỚI: MŨI TÊN ARROW ====================
@onready var arrow: AnimatedSprite2D = $TextureRect/arrow


# Dictionary texture
var period_icons: Dictionary = {}

# Enum TimeOfDay (giữ nguyên như cũ)
enum TimeOfDay {
	MORNING, # 05:00 - 09:59
	NOON,    # 10:00 - 12:59
	AFTERNOON,# 13:00 - 15:59
	SUNSET,  # 16:00 - 17:59
	EVENING, # 18:00 - 21:59
	NIGHT    # 22:00 - 04:59
}

func _ready() -> void:
	# Tạo dictionary từ các icon
	period_icons = {
		TimeOfDay.MORNING: icon_morning.texture,
		TimeOfDay.NOON: icon_noon.texture,
		TimeOfDay.AFTERNOON: icon_afternoon.texture,
		TimeOfDay.SUNSET: icon_sunset.texture,
		TimeOfDay.EVENING: icon_evening.texture,
		TimeOfDay.NIGHT: icon_night.texture
	}
	
	# Ẩn các icon con
	for icon in [icon_morning, icon_noon, icon_afternoon, icon_sunset, icon_evening, icon_night]:
		if icon:
			icon.visible = false
	
	# Kết nối signal từ bộ đếm chính
	DayAndNightCycleManager.time_tick.connect(_on_time_tick)
	
# Buộc Godot phải include tất cả texture vào file export
	var icons_to_force = [icon_morning, icon_noon, icon_afternoon, icon_sunset, icon_evening, icon_night]
	
	for icon in icons_to_force:
		if icon and icon.texture:
			icon.texture = icon.texture  # trick quan trọng
	
	# Force arrow (AnimatedSprite2D)
	if arrow and arrow.sprite_frames:
		arrow.sprite_frames = arrow.sprite_frames
	# ============================================================
	
	# Cập nhật lần đầu
	_update_from_current_time()


# ==================== NHẬN THỜI GIAN TỪ MANAGER ====================
func _on_time_tick(day: int, hour: int, minute: int) -> void:
	# Cập nhật Day Label
	if day_label:
		day_label.text = "DAY " + str(day)
	
	# Cập nhật icon theo giờ
	var current_period = _get_time_of_day(hour)
	_update_icon(current_period)
	
	# ==================== THÊM: CẬP NHẬT MŨI TÊN ====================
	_update_arrow(hour)


# ==================== TÍNH KHOẢNG THỜI GIAN ====================
func _get_time_of_day(hour: int) -> TimeOfDay:
	match hour:
		5, 6, 7, 8, 9:
			return TimeOfDay.MORNING
		10, 11, 12:
			return TimeOfDay.NOON
		13, 14, 15:
			return TimeOfDay.AFTERNOON
		16, 17:
			return TimeOfDay.SUNSET
		18, 19, 20, 21:
			return TimeOfDay.EVENING
		_:
			return TimeOfDay.NIGHT


# ==================== THAY ĐỔI ICON ====================
func _update_icon(period: TimeOfDay) -> void:
	if period_icons.has(period):
		main_icon_container.texture = period_icons[period]
	else:
		push_warning("Không tìm thấy icon cho khoảng thời gian: " + str(period))


# ==================== LOGIC MŨI TÊN - CHIA 3 KHOẢNG ====================
func _update_arrow(hour: int) -> void:
	if not arrow:
		return
	
	var anim_name: String
	
	if hour >= 6 and hour < 13:        
		anim_name = "phase_1"        
	elif hour >= 13 and hour < 18:   
		anim_name = "phase_2"
	else:                            
		anim_name = "phase_3"
	
	# Chạy animation tương ứng
	if arrow.sprite_frames and arrow.sprite_frames.has_animation(anim_name):
		arrow.play(anim_name)


# ==================== CẬP NHẬT BAN ĐẦU ====================
func _update_from_current_time() -> void:
	var mgr = DayAndNightCycleManager
	# Cập nhật ngày
	if day_label:
		day_label.text = "DAY " + str(mgr.current_day)
	
	# Cập nhật icon theo giờ hiện tại
	var current_hour = _calculate_current_hour()
	var period = _get_time_of_day(current_hour)
	_update_icon(period)
	
	# ==================== THÊM: Cập nhật mũi tên ban đầu ====================
	_update_arrow(current_hour)


# Hàm tính giờ từ time
func _calculate_current_hour() -> int:
	var total_minutes: int = int(DayAndNightCycleManager.time / DayAndNightCycleManager.GAME_MINUTE_DURATION)
	var current_day_minutes: int = total_minutes % DayAndNightCycleManager.MINUTES_PER_DAY
	return int(current_day_minutes / DayAndNightCycleManager.MINUTES_PER_HOUR)

# ==================== HÀM LƯU TRẠNG THÁI (gọi khi save game) ====================
func save_day_night_state(save_data: SaveGameDataResource) -> void:
	# Lấy trạng thái icon hiện tại
	var current_hour = _calculate_current_hour()
	var current_period = _get_time_of_day(current_hour)
	save_data.current_time_period = TimeOfDay.keys()[current_period]   # chuyển enum thành String
	
	# Lấy trạng thái mũi tên
	save_data.current_arrow_phase = _get_arrow_phase(current_hour)


# ==================== HÀM LOAD TRẠNG THÁI (gọi khi load game) ====================
func load_day_night_state(save_data: SaveGameDataResource) -> void:
	# Load icon
	if period_icons.has(TimeOfDay[save_data.current_time_period]):
		main_icon_container.texture = period_icons[TimeOfDay[save_data.current_time_period]]
	
	# Load mũi tên
	if arrow:
		var anim_name = "phase_" + str(save_data.current_arrow_phase + 1)
		if arrow.sprite_frames and arrow.sprite_frames.has_animation(anim_name):
			arrow.play(anim_name)


# ==================== HÀM HỖ TRỢ (thêm vào cuối script) ====================
func _get_arrow_phase(hour: int) -> int:
	if hour >= 6 and hour < 13:
		return 0   # phase_1
	elif hour >= 13 and hour < 18:
		return 1   # phase_2
	else:
		return 2   # phase_3

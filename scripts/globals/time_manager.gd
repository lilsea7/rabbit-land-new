extends Node

# ==================== THỜI GIAN GAME ====================
const MINUTES_PER_DAY: int = 24 * 60
const MINUTES_PER_HOUR: int = 60
const GAME_MINUTE_DURATION: float = TAU / MINUTES_PER_DAY

var game_speed: float = 5.0
var initial_day: int = 1
var initial_hour: int = 12
var initial_minute: int = 30

var time: float = 0.0
var current_minute: int = -1
var current_day: int = 0

# ==================== KHOẢNG THỜI GIAN ====================
enum TimeOfDay {
	MORNING,     # 07:00 - 09:59
	NOON,        # 10:00 - 12:59
	AFTERNOON,   # 13:00 - 15:59
	SUNSET,      # 16:00 - 17:59
	EVENING,     # 18:00 - 21:59
	NIGHT        # 22:00 - 04:59
}

signal game_time(time: float)
signal time_tick(day: int, hour: int, minute: int)
signal time_tick_day(day: int)
signal time_of_day_changed(new_period: TimeOfDay)

var current_time_of_day: TimeOfDay = TimeOfDay.NOON

# ==================== READY & PROCESS ====================
func _ready() -> void:
	set_initial_time()
	# Cập nhật khoảng thời gian ban đầu ngay lập tức
	var initial_hour_calc = get_current_hour()
	current_time_of_day = get_time_of_day(initial_hour_calc)
	print("TimeManager khởi tạo - Giờ ban đầu: ", initial_hour_calc, " | Khoảng: ", current_time_of_day)

func _process(delta: float) -> void:
	time += delta * game_speed * GAME_MINUTE_DURATION
	game_time.emit(time)
	recalculate_time()

# ==================== KHỞI TẠO ====================
func set_initial_time() -> void:
	var initial_total_minutes = initial_day * MINUTES_PER_DAY + \
								(initial_hour * MINUTES_PER_HOUR) + initial_minute
	time = initial_total_minutes * GAME_MINUTE_DURATION

# ==================== TÍNH TOÁN ====================
func recalculate_time() -> void:
	var total_minutes: int = int(time / GAME_MINUTE_DURATION)
	var day: int = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute: int = int(current_day_minutes % MINUTES_PER_HOUR)

	if current_minute != minute:
		current_minute = minute
		time_tick.emit(day, hour, minute)
		
		# Kiểm tra thay đổi khoảng thời gian
		_check_time_of_day_change(hour)

	if current_day != day:
		current_day = day
		time_tick_day.emit(day)

# ==================== XỬ LÝ KHOẢNG THỜI GIAN ====================
func get_time_of_day(hour: int) -> TimeOfDay:
	match hour:
		7, 8, 9:
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
			return TimeOfDay.NIGHT   # 22h đến 4h

func _check_time_of_day_change(hour: int) -> void:
	var new_period = get_time_of_day(hour)
	if new_period != current_time_of_day:
		print("Thay đổi khoảng thời gian: ", current_time_of_day, " → ", new_period, " | Giờ: ", hour)
		current_time_of_day = new_period
		time_of_day_changed.emit(new_period)

# ==================== HÀM HỖ TRỢ ====================
func get_current_hour() -> int:
	var total_minutes: int = int(time / GAME_MINUTE_DURATION)
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	return int(current_day_minutes / MINUTES_PER_HOUR)

func get_current_minute() -> int:
	return current_minute

func get_current_day() -> int:
	return current_day

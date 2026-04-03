extends Control

var gold : int = 0:
	set(value):
		gold = value
		
		$CanvasLayer/Currency.text = "Gold : " + str(value)

enum MODE {
	ON,
	OFF
}

var mode : MODE = MODE.OFF:
	set(value):
		mode = value
	
		if value == MODE.OFF:
			$UI.hide()
			Inventory.grid.hide()
		elif value == MODE.ON:
			$UI.show()
			Inventory.grid.show()

func  _ready() -> void:
	$UI.hide()

func _input(event) :
	if even is InputEventKey and event.is_pressed():
		if event.keycode == KEY_U:
			if mode == MODE.ON:
				mode = MODE.OFF
			elif mode == MODE.OFF:
				mode = MODE.ON

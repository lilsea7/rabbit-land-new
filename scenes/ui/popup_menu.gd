extends MarginContainer

@export var help_menu_screen: MarginContainer

func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true

func _on_toggle_help_menu_button_pressed() -> void:
	toggle_visibility(help_menu_screen)
	

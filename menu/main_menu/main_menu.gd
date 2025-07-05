extends Control

signal start_pressed
signal option_pressed
signal credits_pressed
signal quit_pressed


func _on_start_pressed() -> void:
	start_pressed.emit()


func _on_option_pressed() -> void:
	option_pressed.emit()


func _on_credits_pressed() -> void:
	credits_pressed.emit()


func _on_quit_pressed() -> void:
	quit_pressed.emit()

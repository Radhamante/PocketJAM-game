extends Control

signal resume_pressed
signal main_menu_pressed


func _on_resume_pressed() -> void:
	resume_pressed.emit()


func _on_main_menu_pressed() -> void:
	main_menu_pressed.emit()

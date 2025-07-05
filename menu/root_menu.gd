extends CanvasLayer

@onready var game: Node3D
@onready var main_menu: Control = $MainMenu
@onready var pause_menu: Control = $PauseMenu
@onready var credits_menu: Control = $CreditsMenu

const MAIN = preload("res://main.tscn")

var menus

func _ready():
	get_tree().paused = true
	menus = {
		"MAIN": main_menu,
		"PAUSE": pause_menu,
		"CREDITS": credits_menu,
	}
	show_menu("MAIN")
	_reload_game()
	
func _input(event):
	if event.is_action_pressed("pause"):
		_pause_pressed()

func _reload_game():
	print(game)
	if game:
		game.queue_free()
	var new_game = MAIN.instantiate()
	add_child(new_game)
	game = new_game
		
func hide_all_menu():
	for key in menus:
		menus[key].visible = false

func show_menu(_name: String):
	for key in menus:
		menus[key].visible = (key == _name)
		
func _pause_pressed() -> void:
	get_tree().paused = true
	show_menu("PAUSE")

func _on_main_menu_start_pressed() -> void:
	get_tree().paused = false
	hide_all_menu()

func _on_main_menu_credits_pressed() -> void:
	show_menu("CREDITS")

func _on_pause_menu_resume_pressed() -> void:
	get_tree().paused = false
	hide_all_menu()


func _on_main_menu_pressed() -> void:
	show_menu("MAIN")
	_reload_game()

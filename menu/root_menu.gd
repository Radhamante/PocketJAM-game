extends CanvasLayer

@onready var game: Node3D
@onready var main_menu: Control = $MainMenu
@onready var pause_menu: Control = $PauseMenu
@onready var credits_menu: Control = $CreditsMenu
@onready var end_game_menu: Control = $EndGameMenu
@onready var enter_name_menu: Control = $EnterNameMenu
@onready var option_menu: Control = $OptionMenu

const MAIN = preload("res://main.tscn")

var menus
var player_name: String

func _ready():
	get_tree().paused = true
	menus = {
		"MAIN": main_menu,
		"PAUSE": pause_menu,
		"CREDITS": credits_menu,
		"END_GAME": end_game_menu,
		"ENTER_NAME": enter_name_menu,
		"OPTION": option_menu,
	}
	show_menu("ENTER_NAME")
	_reload_game()
	
func _input(event):
	if event.is_action_pressed("pause"):
		_pause_pressed()

func _reload_game():
	if game:
		game.queue_free()
	var new_game = MAIN.instantiate()
	add_child(new_game)
	game = new_game
	game.game_ended.connect(_on_game_ended)
		
func hide_all_menu():
	for key in menus:
		menus[key].visible = false

func show_menu(_name: String):
	for key in menus:
		menus[key].visible = (key == _name)
		
func _pause_pressed() -> void:
	get_tree().paused = true
	show_menu("PAUSE")
	
func _on_game_ended(gamer_saved: int, day_time: float) -> void:
	show_menu("END_GAME")
	game.queue_free()
	end_game_menu.setup(player_name, gamer_saved, day_time)

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

func _on_game_quit_pressed() -> void:
	get_tree().quit()


func _on_enter_name_menu_enter_pressed(_name: String) -> void:
	player_name = _name
	show_menu("MAIN")


func _on_main_menu_option_pressed() -> void:
	show_menu("OPTION")

extends Control

@onready var send_score_request: HTTPRequest = $send_score
@onready var query_leaderboard_request: HTTPRequest = $query_leaderboard

@onready var leaderboard: VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/leaderboard

@onready var gamer_saved_element: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/gamer_saved
@onready var day_time_element: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/day_time

signal quit_pressed
signal main_menu_pressed


func setup(_name: String, _gamer_saved: int, _day_time: float):
	gamer_saved_element.text = str(_gamer_saved)
	day_time_element.text = str(_day_time)
	
	send_score(_name, _gamer_saved, _day_time)

func send_score(_name: String, _gamer_saved: int, _day_time: float):
	send_score_request.request_completed.connect(_on_send_score_request_completed)
	var url = "https://pocketjam.radhamante.fr/leaderboards/24b254de-936f-4e0e-94be-bcebed90a2bb/scores"
	var headers = ["Content-Type: application/json"]
	var json_body = {
		"player_name": _name,
		"score": _day_time
	}
	var error = send_score_request.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(json_body)
	)

	if error == OK:
		print("Requête POST envoyée avec succès")
	else:
		print("Erreur HTTP : ", error)
		
func _on_send_score_request_completed(result, response_code, headers, body) -> void:
	query_leaderboard()


func query_leaderboard():
	query_leaderboard_request.request_completed.connect(_on_leaderboard_request_completed)
	var error = query_leaderboard_request.request("https://pocketjam.radhamante.fr/leaderboards/24b254de-936f-4e0e-94be-bcebed90a2bb/scores")
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _on_leaderboard_request_completed(result, response_code, headers, body) -> void:
	# Check if the request was successful
	print(response_code)
	if response_code == 200:
		# Parse the JSON response
		var json = JSON.new()
		var error = json.parse(body.get_string_from_utf8())

		if error == OK:
			for n in leaderboard.get_children():
				leaderboard.remove_child(n)
				n.queue_free()


			var response_data = json.get_data()
			# Process the response data as needed
			for item in response_data:
				# Assuming response_data is a list of dictionaries
				# Add your logic here to handle each item
				print(item)
				var one_score = Label.new()
				one_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				one_score.text = item["player_name"] + " : " + str(item["score"])
				leaderboard.add_child(one_score)
		else:
			push_error("An error occurred while parsing the JSON.")
	else:
		push_error("An error occurred. Response code: ", response_code)

func _on_quit_pressed() -> void:
	quit_pressed.emit()

func _on_main_menu_pressed() -> void:
	main_menu_pressed.emit()

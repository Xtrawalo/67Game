extends Node2D
@onready var label6 = $"6"
@onready var label7 = $"7"
@onready var label67 = $"67"
@onready var timer = $Timer
@onready var scoretable =$Score
@onready var score_label = $LabelScoreN
@onready var score_label2 = $Score/LabelScoreN


var score = 0
var current_label = ""
var game_over = false

func _ready() -> void:
	timer.start()
	hide_all_labels()
	scoretable.visible = false
	score_label.text = "Score: %d" % score  # Update the label on screen
	score_label2.text = "Score: %d" % score  # Update the label on screen

func hide_all_labels():
	label6.visible = false
	label7.visible = false
	label67.visible = false


func _on_timer_timeout() -> void:
	if game_over:
		return
	hide_all_labels()
	var random_choice = randi() % 3
	if random_choice == 0:
		label6.visible = true
		current_label = "6"
	elif random_choice == 1:
		label7.visible = true
		current_label = "7"
	else:
		label67.visible = true
		current_label = "67"
	$ReactionTimer.start()

func _input(event):
	if game_over or !event.is_pressed():
		return

	if current_label == "6" and Input.is_action_pressed("ui_right"):
		correct()
	elif current_label == "7" and Input.is_action_pressed("ui_left"):
		correct()
	elif current_label == "67" and Input.is_action_pressed("ui_accept"): # Space by default
		correct()
	elif current_label != "":
		lose()

func correct():
	$ReactionTimer.stop()  # Stop the reaction countdown
	score += 1
	score_label.text = "Score: %d" % score  # Update the label on screen
	score_label2.text = "Score: %d" % score  # Update the label on screen
	hide_all_labels()
	current_label = ""
	timer.start(1.0)  # Start next round


func lose():
	game_over = true
	hide_all_labels()
	scoretable.visible = true


func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_reaction_timer_timeout() -> void:
	if current_label != "":  # Player didn’t press any key in time
		lose()

extends Node

var game_end_timer: int = 0
var winner: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_end_timer> 0:
		game_end_timer -= 1
		if game_end_timer == 0:
			print("%s wins" % winner)
			get_tree().paused = true

func _on_player_a_dead():
	winner = "Player B"
	game_end_timer = 10

func _on_player_b_dead():
	winner = "Player A"
	game_end_timer = 10

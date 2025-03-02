extends Node

signal player_win(winner: int)

var game_end_timer: int = 0

@onready var tree = get_tree()
	
func _input(event):
	if event.is_action_pressed("Restart") and tree.is_paused():
		tree.set_pause(false)
		tree.reload_current_scene()
	if event.is_action_pressed("Quit") and tree.is_paused():
		tree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		tree.quit()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_end_timer> 0:
		game_end_timer -= 1
		if game_end_timer == 0:
			tree.set_pause(true)

func _on_player_damage(player, health):
	if health == 0:
		player_win.emit(player)
		game_end_timer = 10

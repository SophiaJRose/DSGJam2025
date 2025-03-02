extends Control

@onready var p1win = $P1WinText
@onready var p2win = $P2WinText
@onready var retryOrQuit = $RetryOrQuit
@onready var p1Heart1 = $P1Hearts/P1Heart1
@onready var p1Heart2 = $P1Hearts/P1Heart2
@onready var p1Heart3 = $P1Hearts/P1Heart3
@onready var p2Heart1 = $P2Hearts/P2Heart1
@onready var p2Heart2 = $P2Hearts/P2Heart2
@onready var p2Heart3 = $P2Hearts/P2Heart3
@onready var hearts = [[p1Heart1, p1Heart2, p1Heart3], [p2Heart1, p2Heart2, p2Heart3]]


func _on_root_player_win(winner: int):
	retryOrQuit.visible = true
	if winner == 2:
		p1win.visible = true
	else:
		p2win.visible = true

func _on_player_damage(player, health):
	hearts[player-1][health].visible = false
	

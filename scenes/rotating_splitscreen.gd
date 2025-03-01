extends Control

@onready var topCam: Camera3D = $TopScreenContainer/TopScreenViewport/TopScreenCam
@onready var bottomCam: Camera3D = $BottomScreenContainer/BottomScreenViewport/BottomScreenCam

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	topCam.rotation.z = -rotation
	bottomCam.rotation.z = -rotation

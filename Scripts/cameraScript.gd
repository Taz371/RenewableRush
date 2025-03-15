extends Camera2D
class_name MainCamera

@onready var camera: MainCamera = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("RightArrow") and camera.position.x < 500:
		camera.position.x += 500 * delta
	if Input.is_action_pressed("LeftArrow") and camera.position.x > -500:
		camera.position.x -= 500 * delta

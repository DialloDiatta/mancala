extends Sprite2D

@export var rest_texture: Texture2D
@export var click_texture: Texture2D

func _ready() -> void :
    texture = rest_texture
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(_delta: float) -> void :
    global_position = get_global_mouse_position()

    if Input.is_action_pressed("click"):
        texture = click_texture
    else:
        texture = rest_texture

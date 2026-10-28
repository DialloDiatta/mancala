extends Control

signal change_board_state(new_state)

var piece_value: int
@export var texture: Texture
@onready var object = $Object

var is_dragging = false
var initialPos = Vector2.ZERO



@export var wobble: bool = true

func _ready() -> void :

    self.gui_input.connect(_on_gui_input)

    object.texture = texture
    set_texture_size()


func _process(delta):
    if is_dragging:
        self.global_position = get_global_mouse_position() - initialPos
        wiggle()

func _input(event):
    if event.is_action_released("click"):
        is_dragging = false
    if Input.is_action_just_pressed("clear"):
        self.queue_free()

func _on_gui_input(event):
    if event.is_action_pressed("click"):
        is_dragging = true
        initialPos = self.get_local_mouse_position()


    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_RIGHT:
            self.queue_free()

func wiggle():
    if wobble:
        var time = Time.get_ticks_msec() / 1000.0
        rotation = sin(time * 3) * 0.15

func current_piece_value():
    return piece_value

func _on_area_2d_mouse_entered() -> void :
    print("Piece Value : ", piece_value)
    SignalHandler.clear_bead.emit(self, piece_value)

func _on_mouse_entered() -> void :

    if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
        print("PieceControl Mouse Entered")
        self.queue_free()

func set_texture_size():
    var texture_size = texture.get_size()
    object.size = texture_size
    print(texture_size)
    print(object.size)

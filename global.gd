extends Node

var current_letter_index: int = -1

var trail_on: bool = true


func _input(event: InputEvent) -> void :
    if event.is_action_pressed("escape"):
        var current_scene = str(get_tree().get_current_scene().scene_file_path)
        var main_menu = "res://ui/main_menu.tscn"
        if !current_scene == main_menu:
            SceneManager.change_scene("res://ui/main_menu.tscn")
    if event.is_action_pressed("full screen"):
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _unhandled_key_input(event: InputEvent) -> void :
    if not event.is_pressed():
        var typed_event = event as InputEventKey


func clear_all() -> void :
    var clear_event = InputEventAction.new()
    clear_event.action = "clear"
    clear_event.pressed = true
    Input.parse_input_event(clear_event)
    reset_clear_all()

func reset_clear_all():
    var clear_event = InputEventAction.new()
    clear_event.action = "clear"
    clear_event.pressed = false
    Input.parse_input_event(clear_event)

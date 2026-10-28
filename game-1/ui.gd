extends CanvasLayer

@onready var timer: Timer = $Timer

var last_click_time = 0.0
var double_click_threshold = 0.5

var menu_open: bool = false

func _ready() -> void :

    timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void :
    if Input.is_action_just_pressed("tool_select"):
        $SelectionWheel.open()
    elif Input.is_action_just_released("tool_select"):
        $SelectionWheel.close()



func _on_outside_gui_input(event: InputEvent) -> void :
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            var current_time = Time.get_ticks_msec() / 1000.0
            if current_time - last_click_time <= double_click_threshold:
                var input_event = InputEventAction.new()
                input_event.action = "tool_select"
                input_event.pressed = true
                Input.parse_input_event(input_event)
                timer.stop()
                menu_open = true
            else:

                timer.start(double_click_threshold)
                last_click_time = current_time
        if !event.pressed:
            var release_event = InputEventAction.new()
            release_event.action = "tool_select"
            release_event.pressed = false
            Input.parse_input_event(release_event)















func _on_timer_timeout():

        print("Timer: Timeout")

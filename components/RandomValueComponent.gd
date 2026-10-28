extends Control
class_name RandomValueComponent

signal puzzle_stopped

@onready var settings: Control = $"../Settings"
@onready var timer: Timer = $"../Timer"

@export var refresh_button: Button

@export var label: Label


var rng = RandomNumberGenerator.new()
var last_number: int = -1
var current_puzzle: Array = []
var current_puzzle_solution: int
var stop_pressed: bool = false

func _ready() -> void :
    refresh_button.pressed.connect(on_refresh_pressed)


func _input(event: InputEvent) -> void :
    if event.is_action_pressed("refresh"):
        on_refresh_pressed()






func random():
    rng.randomize()
    var new_number = rng.randi_range(settings.lowest, settings.highest)

    while new_number == last_number:
        new_number = rng.randi_range(settings.lowest, settings.highest)

    last_number = new_number

    return new_number

func on_refresh_pressed():
    random()
    var blocks = get_tree().get_nodes_in_group("blocks")
    for node in blocks:
        node.queue_free()

func generate_next_puzzle():
    un_stop_puzzle()
    current_puzzle = []
    current_puzzle_solution = 0
    for n in settings.number_of_addends:
        var value = random()
        current_puzzle.append(value)
    for n in current_puzzle:
        current_puzzle_solution += n

func run_puzzle():
    for addend in current_puzzle:
        if stop_pressed:
            break
        label.text = str(addend)
        timer.start(settings.flash_time)
        SignalHandler.say_addend.emit(addend)
        await timer.timeout

        label.text = "?"

    print(current_puzzle)
    puzzle_stopped.emit()

func stop_puzzle():
    stop_pressed = true
    timer.stop()
    label.text = "START"

func un_stop_puzzle():
    stop_pressed = false

extends Control

var is_running: bool = false

@onready var random_value_component: RandomValueComponent = $RandomValueComponent
@onready var confirmation: Label = $Confirmation
@onready var answer: LineEdit = %Answer
@onready var number: Label = $Number
@onready var play: Button = $InputFields / Play
@onready var settings = $Settings
@onready var correct: AudioStreamPlayer = $correct





var ready_for_next_puzzle: bool = true
var incorrect: bool = false

func _ready() -> void :
    random_value_component.puzzle_stopped.connect(unlock_line_edit)
    settings.toggle_off.connect(_on_settings_toggled)
    SignalHandler.say_addend.connect(say_addend)

func _on_play_pressed() -> void :
    if !is_running:
        random_value_component.generate_next_puzzle()
        random_value_component.run_puzzle()
        confirmation.visible = false
        is_running = true
        play.text = "Stop"

        ready_for_next_puzzle = false
        answer.editable = false
    elif is_running:
        random_value_component.stop_puzzle()
        reset_playspace()
    print("Is Running: " + str(is_running))









func _on_settings_toggled(toggled_on: bool) -> void :
    var settings_button = $InputFields / Settings
    if toggled_on:
        get_tree().paused = true
        settings.visible = true
    else:
        get_tree().paused = false
        settings_button.button_pressed = false
        settings.visible = false

func _on_check_pressed() -> void :
    confirmation.visible = true
    if answer.text == str(random_value_component.current_puzzle_solution):
        number.text = str(random_value_component.current_puzzle_solution)
        confirmation.text = "Correct!"
        correct.play()
        reset_playspace()
    else:
        confirmation.text = "Try Again..."
        await get_tree().process_frame
        answer.grab_focus()
        incorrect = true

func _on_replay_pressed() -> void :
    random_value_component.un_stop_puzzle()
    random_value_component.run_puzzle()
    is_running = true
    incorrect = false
    answer.text = ""
    answer.editable = false

func reset_playspace():
    is_running = false
    play.text = "Play"
    answer.text = ""
    ready_for_next_puzzle = true
    incorrect = false

func _input(event: InputEvent) -> void :
    if Input.is_action_just_pressed("submit"):
        answer.release_focus()
        if is_running:
            return
        if incorrect:
            if !check_before_replay():
                _on_replay_pressed()
            return
        if !ready_for_next_puzzle:
            _on_check_pressed()
            return
        if ready_for_next_puzzle:
            _on_play_pressed()
            return

func unlock_line_edit():
    answer.release_focus()
    is_running = false
    answer.editable = true
    await get_tree().process_frame
    answer.grab_focus()



func check_before_replay():
    if answer.text == str(random_value_component.current_puzzle_solution):
        number.text = str(random_value_component.current_puzzle_solution)
        confirmation.text = "Correct!"
        reset_playspace()
        return true
    else:
        return false

func say_addend(addend: int):
    if settings.tts_on:
        var voices = DisplayServer.tts_get_voices_for_language("en")
        var voice_id: String = voices[1]
        var text: String = str(addend)

        DisplayServer.tts_speak(text, voice_id)
        print("Say : ", addend)

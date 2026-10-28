extends Control


var playspace_value: int
@onready var left_hand: Sprite2D = %LeftHand
@onready var right_hand: Sprite2D = %RightHand

var root_finger_image_path = "res://assets/fingers/fingers_"

func _ready() -> void :
    SignalHandler.update_playspace.connect(_update_playspace)

func refresh_playspace():
    if playspace_value >= 11:
        finger_show_ten()
    elif playspace_value == 10:
        finger_show_ten()

    elif !playspace_value >= 6:
        if playspace_value <= 0:
            left_hand.texture = load(root_finger_image_path + "0.svg")
            right_hand.texture = load(root_finger_image_path + "0.svg")
        else:
            var current_playspace_value = playspace_value
            var finger_image_path = root_finger_image_path + str(current_playspace_value) + ".svg"
            left_hand.texture = load(finger_image_path)
            right_hand.texture = load(root_finger_image_path + "0.svg")
            print(finger_image_path)
            print("Playspace Value : ", playspace_value)
    elif playspace_value >= 6:
        var current_playspace_value = playspace_value
        var finger_image_path = root_finger_image_path + str(current_playspace_value - 5) + ".svg"
        right_hand.texture = load(finger_image_path)
        print(finger_image_path)
        print("Playspace Value : ", playspace_value)

func finger_show_ten():
    right_hand.texture = load(root_finger_image_path + "5.svg")
    left_hand.texture = load(root_finger_image_path + "5.svg")

func _on_african_math_banner_pressed() -> void :
    Global.clear_all()
    Global.reset_clear_all()

func _update_playspace(change: int, signal_id: String):
    if signal_id == "add":
        playspace_value += change
        refresh_playspace()
    if signal_id == "erase":
        playspace_value -= change
        refresh_playspace()

func _on_mancala_math_logo_pressed() -> void :
    SceneManager.change_scene("res://ui/main_menu.tscn")


func _on_trail_button_toggled(toggled_on: bool) -> void :
    Global.trail_on = toggled_on


func _on_hands_button_toggled(toggled_on: bool) -> void :
    var hands_parent = $Hands
    hands_parent.visible = toggled_on


func _on_collapse_toggled(toggled_on: bool) -> void :
    var button_parent = $ButtonContainer
    button_parent.visible = toggled_on

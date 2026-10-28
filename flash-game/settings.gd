extends Control

signal toggle_off(bool)

var number_of_addends: int = 2
var lowest: int = 1
var highest: int = 10
var flash_time: float = 2.0

var timeout
var font_size
var text_color
var background_color

var tts_on: bool = true

@onready var addends: SpinBox = %Addends
@onready var lowest_input: SpinBox = %LowestInput
@onready var highest_input: SpinBox = %HighestInput
@onready var flash_time_input: LineEdit = %FlashTimeInput
@onready var timer: Timer = $"../Timer"
@onready var background: ColorRect = $"../Background"
@onready var number: Label = $"../Number"
@onready var font_size_label: Label = $PanelContainer / VBoxContainer / VBoxContainer / FontSizeLabel



func _ready() -> void :
    addends.value = number_of_addends
    lowest_input.value = lowest
    highest_input.value = highest
    flash_time_input.text = str(flash_time)

func _on_close_pressed() -> void :
    self.toggle_off.emit(false)

func _on_addends_value_changed(value: float) -> void :
    number_of_addends = addends.value

func _on_lowest_input_value_changed(value: float) -> void :
    lowest = lowest_input.value


func _on_highest_input_value_changed(value: float) -> void :
    highest = highest_input.value


func _on_flash_time_input_editing_toggled(toggled_on: bool) -> void :
    flash_time = float(flash_time_input.text)

func _on_color_picker_button_color_changed(color: Color) -> void :
    background.color = color


func _on_text_color_picker_color_changed(color: Color) -> void :
    number.add_theme_color_override("font_color", color)


func _on_decrease_font_size_pressed() -> void :
    change_font_size(false)

func _on_increase_font_size_pressed() -> void :
    change_font_size(true)


func change_font_size(increase: bool):
    var ratio = 1.1
    var current_size = number.get_theme_font_size("font_size")
    var new_size

    if increase:
        new_size = current_size * ratio
    else:
        new_size = current_size / ratio

    number.add_theme_font_size_override("font_size", new_size)
    set_current_font_size_label()

func set_current_font_size_label():
    font_size_label.text = "The current font size is: " + str(number.get_theme_font_size("font_size"))


func _on_check_button_toggled(toggled_on: bool) -> void :
    tts_on = toggled_on


func _on_mute_toggled(toggled_on: bool) -> void :
    AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)


func _on_mute_music_toggled(toggled_on: bool) -> void :
    AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), toggled_on)

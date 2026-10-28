
class_name MySecretPhrase extends Node








signal secret_phrase_typed



@export var secret_phrase: String = "LOVEYOUDAD":
    set(value):
        secret_phrase = value.to_upper()


var _typed_phrase: String = ""


func _unhandled_input(event: InputEvent) -> void :

    if event is InputEventKey:
        if not event.is_pressed():

            return


        if event.keycode <= 255:
            _typed_phrase += String.chr(event.keycode)
            _check_phrase()


func _check_phrase() -> void :

    _typed_phrase = _typed_phrase.right(secret_phrase.length())


    print(_typed_phrase)

    if _typed_phrase == secret_phrase:
        secret_phrase_typed.emit()
        SceneManager.change_scene("res://game-3/game_3.tscn")
        print("code success")
        _typed_phrase = ""
    if _typed_phrase == "FLASH":
        SceneManager.change_scene("res://flash-game/flash.tscn")

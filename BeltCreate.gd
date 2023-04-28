#Godot 4.0
class_name BeltCreatePopup
extends PanelContainer


var buttons = []

signal selected(id,pos)

func handle(id: int):
#	for button in buttons:
#		button.pressed = false
	print("clicked:",id_to_name(id))
	hide()
	selected.emit(id,position)

# func hide():
# 	visible = false
	# #remove focus #actually automatic when hidden
	# for button in buttons:
	# 	button.focus_mode = FocusModeEnum.NONE

func id_to_name(id:int):
	return buttons[id].name

func _ready():
	for i in range($box.get_child_count()):
		buttons.append($box.get_child(i))
		buttons[i].button_down.connect(handle.bind(i))
	focus_exited.connect(hide)
	focus_exited.connect(func f():print("hello"))
	focus_entered.connect(func f():print("hello"))
#	(func f():print("wht")).call()

func connect_to_signal(_callable):
	selected.connect(_callable)

func _screen_size():
	return get_parent().size

func show_popup(pos):
	pos=pos.clamp(Vector2(), _screen_size()-size)
	position = pos
	show()
#	grab_focus()
	#grab_focus.call_deferred()
	# print(has_focus())


func _on_click_block_gui_input(event):
	pass # Replace with function body.

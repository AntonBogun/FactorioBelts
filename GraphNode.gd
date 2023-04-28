extends GraphNode

var type
var belt_display=preload("res://belt_display.tscn")
var interactive_belt_display=preload("res://interactive_belt_display.tscn")
var to_col=Color.GREEN
var from_col=Color.BLUE

signal delete


#type expected to be a string
#recognized: Input,Splitter,Underground,OneSide,Output
func init(_type):
	type=_type
	title=type
	if type=="Input":
		# $div/Belts/ShowMore.hide()
		$div/Belts/ThroughputLabel.text="Max Output:"
		$div/Belts/DetailedInfo/InputLabel.hide()
		$div/Belts/DetailedInfo/InputBeltDisplay.hide()
		var _i=interactive_belt_display.instantiate()
		$div/Belts/ThroughputBeltDisplay.add_child(_i)
		set_slot(0,0,0,Color.GREEN,1,0,Color.BLUE)
		var _o=belt_display.instantiate()
		print((func f(x): 2*x).call(2))
		_o.init("True Output",[0,0],"/m")
	# elif type==#
	else:
		set_slot(0,1,0,Color.GREEN,1,0,Color.BLUE)



func connect_to_delete(_callable):
	delete.connect(_callable)

func _on_focus_changed(control:Control):
	if control != null:
		print(control.name, "print at GraphNode.gd")

func _ready():
	get_viewport().gui_focus_changed.connect(_on_focus_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_show_more_toggled(button_pressed):
	if button_pressed:
		$div/Belts/DetailedInfo.show()
		$div/Belts/ShowMore.text="Show Less"
	else:
		$div/Belts/DetailedInfo.hide()
		$div/Belts/ShowMore.text="Show More"


func _on_delete_toggled(button_pressed):
	if button_pressed:
		$div/Delete.text="Are you sure?"
	else:
		delete.emit()



func _on_delete_focus_exited():
	$div/Delete.text="Delete"
	$div/Delete.set_pressed_no_signal(false)

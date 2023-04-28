extends GraphNode

var type
var belt_display=preload("res://belt_display.tscn")
var interactive_belt_display=preload("res://interactive_belt_display.tscn")
var num_REAL_slots=0

signal delete



func prepare_append_REAL_slot(left_enabled,left_type,left_color,right_enabled,right_type,right_color):
	num_REAL_slots+=1
	add_child(Control.new())
	set_slot(num_REAL_slots,left_enabled,left_type,left_color,right_enabled,right_type,right_color)



func finalize_slots():
	if num_REAL_slots==0:
		return
	var slot_control_size=$ind0/div.size
	prints("",slot_control_size)
	slot_control_size.y/=num_REAL_slots
	print(1)
	for i in range(1,num_REAL_slots+1):
		get_child(i).custom_minimum_size=slot_control_size

#type expected to be a string
#recognized: Input,Splitter,Underground,OneSide,Output
func init(_type):
	type=_type
	title=type
	if type=="Input":
		# $div/Belts/ShowMore.hide()
		$ind0/div/Belts/ThroughputLabel.text="Max Output:"
		$ind0/div/Belts/DetailedInfo/InputLabel.hide()
		$ind0/div/Belts/DetailedInfo/InputBeltDisplay.hide()
		
		prepare_append_REAL_slot(0,0,Color.GREEN,1,0,Color.BLUE)
		
		var _i=interactive_belt_display.instantiate()
		$ind0/div/Belts/ThroughputBeltDisplay.add_child(_i)
		
		var _o=belt_display.instantiate()
		_o.init("True Output",[0,0],"/m")

	elif type=="Splitter":
		prepare_append_REAL_slot(1,0,Color.YELLOW,1,0,Color.GOLD)
		prepare_append_REAL_slot(1,1,Color.ORANGE,1,1,Color.GOLD)
		
		var _t1=belt_display.instantiate()
		_t1.init("Output Left",[0,0],"/m")
		var _t2=belt_display.instantiate()
		_t2.init("Output Right",[0,0],"/m")
		$ind0/div/Belts/ThroughputBeltDisplay.add_child(_t1)
		$ind0/div/Belts/ThroughputBeltDisplay.add_child(_t2)
		
		var _i1=belt_display.instantiate()
		_i1.init("Input Left",[0,0],"/m")
		var _i2=belt_display.instantiate()
		_i2.init("Input Right",[0,0],"/m")
		$ind0/div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i1)
		$ind0/div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i2)

		var _o1=belt_display.instantiate()
		_o1.init("Max Output Left",[0,0],"/m")
		var _o2=belt_display.instantiate()
		_o2.init("Max Output Right",[0,0],"/m")
		$ind0/div/Belts/DetailedInfo/OutputBeltDisplay.add_child(_o1)
		$ind0/div/Belts/DetailedInfo/OutputBeltDisplay.add_child(_o2)
	
	elif type=="Underground" or type=="OneSide":
		prepare_append_REAL_slot(true,0,Color.YELLOW,false,0,Color.BLUE)
		prepare_append_REAL_slot(true,1,Color.PURPLE,true,1,Color.GOLD)
		prepare_append_REAL_slot(true,2,Color.ORANGE,false,2,Color.BLUE)
		
		var _t1=belt_display.instantiate()
		_t1.init("Output",[0,0],"/m")
		$ind0/div/Belts/ThroughputBeltDisplay.add_child(_t1)
		
		var _i1=belt_display.instantiate()
		_i1.init("Input Left",[0,0],"/m")
		var _i2=belt_display.instantiate()
		_i2.init("Input Middle",[0,0],"/m")
		var _i3=belt_display.instantiate()
		_i3.init("Input Right",[0,0],"/m")
		$ind0/div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i1)
		$ind0/div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i2)
		$ind0/div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i3)

		var _o1=belt_display.instantiate()
		_o1.init("Max Output",[0,0],"/m")
		$ind0/div/Belts/DetailedInfo/OutputBeltDisplay.add_child(_o1)
		
	elif type=="Output":
		$ind0/div/Belts/ThroughputLabel.text="Desired Output:"
		$ind0/div/Belts/ShowMore.hide()
		$ind0/div/Belts/DetailedInfo.show()
		$ind0/div/Belts/DetailedInfo/OutputLabel.hide()
		$ind0/div/Belts/DetailedInfo/OutputBeltDisplay.hide()
		$ind0/div/Belts/DetailedInfo/InputLabel.text="Input:"

		
		prepare_append_REAL_slot(true,0,Color.GREEN,true,0,Color.GREEN)
		
		var _i=interactive_belt_display.instantiate()
		$ind0/div/Belts/ThroughputBeltDisplay.add_child(_i)
		
		var _o=belt_display.instantiate()
		_o.init("True Input",[0,0],"/m")
		
	else:
		print("Error: unrecognized type in GraphNode.gd")
		return
	finalize_slots()



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
		$ind0/div/Belts/DetailedInfo.show()
		$ind0/div/Belts/ShowMore.text="Show Less"
	else:
		$ind0/div/Belts/DetailedInfo.hide()
		$ind0/div/Belts/ShowMore.text="Show More"


func _on_delete_toggled(button_pressed):
	if button_pressed:
		$ind0/div/Delete.text="Are you sure?"
	else:
		delete.emit()



func _on_delete_focus_exited():
	$ind0/div/Delete.text="Delete"
	$ind0/div/Delete.set_pressed_no_signal(false)

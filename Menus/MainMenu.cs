using Godot;
using System;


public partial class MainMenu : Control
{

	private void _on_adventure_button_pressed()
	{
		// Replace with function body.
	}


	private void _on_level_select_button_pressed()
	{
		var levelScene = ResourceLoader.Load<PackedScene>("res://Menus/LevelSelectMenu.tscn").Instantiate();
		GetTree().Root.AddChild(levelScene);
		QueueFree();
	}


	private void _on_options_button_pressed()
	{
		var optScene = ResourceLoader.Load<PackedScene>("res://Menus/OptionsMenu.tscn").Instantiate();
		GetTree().Root.AddChild(optScene);
		QueueFree();
	}


	private void _on_exit_button_pressed()
	{
		GetTree().Quit();
	}
	
}


using Godot;
using System;

public partial class node_2d : Node2D
{
	/// <summary>
	/// test
	/// </summary>
	[Export]
	main_sprite ms;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		// int t = ((main_sprite)ms).tt;
		// GD.Print(t.ToString());
		int i = 0;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		GD.Print("test");
	}
}

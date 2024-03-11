using Godot;
using System;

public partial class cyan_tank : CharacterBody2D
{
Node2D turret;
	CharacterBody2D player;
	Node2D gun;
	[Export] float speed = 75f;
	
	public override void _Ready()
	{
		turret = GetNode<Node2D>("turret");
		gun = GetNode<Node2D>("turret/Gun");
		player = GetNode<CharacterBody2D>("../tank_hull");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		turret.Rotation = ( (player.Position - this.Position).Angle() );
	}

	public void shoot()
	{
		RigidBody2D bullet = (RigidBody2D) ResourceLoader.Load<PackedScene>("res://Enemies/cyanEnemy/ghost_bullet.tscn").Instantiate();
		bullet.GlobalPosition = this.Position;
		bullet.Rotation = ((player.Position - this.Position).Angle());
		bullet.GlobalPosition = ((player.Position - this.Position).Normalized() * 10) + this.Position;
		bullet.LinearVelocity = bullet.Transform.X * speed;
		GetParent().AddChild(bullet);
	}

	private void _on_timer_timeout()
	{
		shoot();
	}
}

using Godot;
using System;

public partial class BossTank : CharacterBody2D
{
	Node2D turret;
	CharacterBody2D player;
	RayCast2D raycast;
	Timer timer;
	 float speed = 125;
	
	public override void _Ready()
	{
		turret = GetNode<Node2D>("turret");
		player = GetNode<CharacterBody2D>("../tank_hull");
		timer = GetNode<Timer>("Timer");
		raycast = GetNode<RayCast2D>("RayCast2D");
		raycast.GlobalPosition = GlobalPosition;
		raycast.AddException(player);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		turret.Rotation = ( (player.Position - this.Position).Angle() );
		raycast.TargetPosition = player.Position - Position;
		if(timer.IsStopped() && !raycast.IsColliding())
		{
			shoot();
			timer.Start(2f);
		}
	}

	public void shoot()
	{
		RigidBody2D bullet = (RigidBody2D) ResourceLoader.Load<PackedScene>("res://Enemies/blueEnemy/big_bullet.tscn").Instantiate();
		RigidBody2D bullet2 = (RigidBody2D) ResourceLoader.Load<PackedScene>("res://Enemies/blueEnemy/big_bullet.tscn").Instantiate();
		bullet.Scale =  new Vector2(0.4f,0.4f);
		bullet2.Scale = new Vector2(.4f,.4f);
		bullet.GlobalPosition = this.Position;
		bullet2.GlobalPosition = this.Position;
		
		bullet.Rotation = ((player.Position - this.Position).Angle());
		bullet2.Rotation = ((player.Position - this.Position).Angle());
		var angle1 = (player.Position - this.Position).Angle() + (float)Math.PI/6;
		var angle2 = (player.Position - this.Position).Angle() - (float)Math.PI/6;
		bullet.GlobalPosition = (Vector2.FromAngle(angle1) * 15) + this.Position;
		bullet2.GlobalPosition = (Vector2.FromAngle(angle2) * 15) + this.Position;
		bullet.LinearVelocity = bullet.Transform.X * speed;
		bullet2.LinearVelocity = bullet2.Transform.X * speed;

		GetParent().AddChild(bullet);
		GetParent().AddChild(bullet2);
	}

	private void _on_timer_timeout()
	{
	}

}

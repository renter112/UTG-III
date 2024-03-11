using Godot;
using System;
using System.Collections.Generic;

public partial class level : Node2D
{
	public Vector2 baseGrid;
	public Vector2 playerPos;
	public List<Vector3> blockList = new List<Vector3>();
	public List<CharacterBody2D> enemyList = new List<CharacterBody2D>();
	public string level_title { get; set; } = "1";
	public int attempt_counter { get; set; } = 1;
	public Area2D finishB;
	public CharacterBody2D tank;
	public double timer = 0;
	public Camera2D cam;
	
	public void parseXML()
	{
		var parser = new XmlParser();
		string temp = "res://levelLoader/levels/"+level_title+".xml";
		parser.Open(temp);
		//parser.Open("res://levelExample/levels/1.xml");
		while (parser.Read() != Error.FileEof)
		{
			if (parser.GetNodeType() == XmlParser.NodeType.Element)
			{
				var nodeName = parser.GetNodeName(); // name of element <level> <grid>..
				var attributesDict = new Godot.Collections.Dictionary(); // values of element x=, y=, type=..
				for(int idx=0;idx<parser.GetAttributeCount();idx++)
					attributesDict[parser.GetAttributeName(idx)] = parser.GetAttributeValue(idx);
				if(nodeName == "grid")
				{
					baseGrid = new Vector2((float)attributesDict["x"], (float)attributesDict["y"]);
				}
				else if(nodeName == "coord")
				{
					var type = 0;
					switch ((string)attributesDict["type"])
					{
						case "hole":
							type = 2;
							break;
						case "block":
							type = 3;
							break;
						case "finish":
							finishB.Position = new Vector2((float)attributesDict["x"]*16 + 8,(float)attributesDict["y"]*16 + 8);
							type = -1;
							break;
						default:
							type = -1;
							return;
					}
					if (type != -1)
					{
						Vector3 tempObj = new Vector3((int)attributesDict["x"],(int)attributesDict["y"],type);
						blockList.Add(tempObj);
					}
				}
				else if(nodeName == "tank")
				{
					if((string)attributesDict["type"] == "p1")
					{
						playerPos = new Vector2(
							(int)attributesDict["x"],
							(int)attributesDict["y"]
						);
					}
				}
				else if (nodeName == "enemy") 
				{
					string name = (string)attributesDict["type"];
					CharacterBody2D enemy = (CharacterBody2D) ResourceLoader.Load<PackedScene>("res://Enemies/"+name+"Enemy/"+name+"_tank.tscn").Instantiate();
					enemy.Position = new Vector2((float)attributesDict["x"]*16 + 8,(float)attributesDict["y"]*16 + 8);
					this.AddChild(enemy); 
					if(name != "cyan")
						enemy.AddToGroup("enemies");
					enemyList.Add(enemy);
				}
			}
		}
	}
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		finishB = GetNode<Area2D>("FinishTile");
		tank = GetNode<CharacterBody2D>("tank_hull");
		parseXML();
		UpdateScale();
		BuildGrid();
		BuildObjects();
		tank.Position =  new Vector2(playerPos.X*16+8,playerPos.Y*16+8 );
		GetNode<Label>("LevelLabel").Text = "";
		GetTree().CallGroup("finishItem","FinishUpdate");
		for (int i=0; i< enemyList.Count; i++)
		{
			GD.Print(enemyList[i].Position);
		}
	}
	public override void _Process(double delta)
	{
		timer += delta;

	}
	
	// Called to build the outline of the grid (and floor)
	public void BuildGrid() 
	{
		int bX = (int) baseGrid.X;
		int bY = (int) baseGrid.Y;
		CreateGridElement(0,0,0,0,1);
		CreateGridElement(bX -1,0,4,0,1);
		CreateGridElement(0,bY -1,0,4,1);
		CreateGridElement(bX -1, bY -1,4,4,1);
		for (int x=1; x < bX -1 ;x++)
		{
			CreateGridElement(x,0,1,0,1);
			CreateGridElement(x, bY -1,3,4,1);
		}
		for (int y=1; y < bY -1;y++){
			CreateGridElement(0,y,0,3,1);
			CreateGridElement(bX -1,y,4,1,1);
		}
		for (int x = 1; x< baseGrid.X - 1; x++)
		{
			for (int y = 1; y < baseGrid.Y -1; y++)
			{
				CreateGridElement(x,y,2,2,0);
			}
		}
	}
	
	public void CreateGridElement(int x, int y, int tx, int ty, int l)
	{
		// this is for editing the cell on the tilemap
		// first is for layer (maybe ground on layer 0, walls on layer1?)
		// second is coords, 3rd is the tileset it's pulling from -> tileset id
		// 4th is coord of the sprite (hover over in tilemap view), 5th is 0 always
		TileMap map = GetNode<TileMap>("Map");
		map.SetCell(l,new Vector2I(x,y),1,new Vector2I(tx,ty),0);
	}
	
	public void BuildObjects()
	{
		for (int i=0; i< blockList.Count; i++)
		{
			switch (blockList[i].Z)
			{
				case 2:
					CreateGridElement((int)blockList[i].X,(int)blockList[i].Y,5,0,1);
					break;
				case 3:
					CreateGridElement((int)blockList[i].X,(int)blockList[i].Y,5,1,1);
					break;
				case 4:
					CreateGridElement((int)blockList[i].X,(int)blockList[i].Y,5,3,1);
					break;
				default:
					return;
			}
		}
	}
	
	public void UpdateScale() 
	{
		cam = GetNode<Camera2D>("cam");
		GD.Print(GetWindow().Size);
		var zoom_x = GetWindow().Size.X / (baseGrid.X*16);
		var zoom_y = GetWindow().Size.Y / (baseGrid.Y*16);
		//cam.Zoom = new Vector2(Math.Min(zoom_x,zoom_y),Math.Min(zoom_x,zoom_y));
		GD.Print(new Vector2(Math.Min(zoom_x,zoom_y),Math.Min(zoom_x,zoom_y)));
	}
	
	private void _on_tank_hull_player_dead()
	{
		// Replace with function body.
		EndLevel(false);
		//EndLevel("fail");
	}
	private void _on_finish_tile_level_finish()
	{
	// Replace with function body.
		EndLevel(true);
	}
	
	private void EndLevel(bool cond) 
	{
		GD.Print(cond);
		var gameScene = ResourceLoader.Load<PackedScene>("res://levelLoader/result_screen.tscn").Instantiate();
		gameScene.Set("cond", cond);
		gameScene.Set("currentLevel", level_title); // Set the level_title property
		gameScene.Set("timeTaken", timer);
		gameScene.Set("attempts", attempt_counter);
		GetTree().Root.AddChild(gameScene);
		GetParent().QueueFree();
	}
}







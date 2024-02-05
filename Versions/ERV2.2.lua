--[[
	/ Emperean Reanimate V2.2
	/ made by: emperss#0
	/ join: discord.gg/5PMtk6PJf5
	/ for changelogs and my amazing community! follow the rules tho.
	/ dont steal or change credits
	*fun fact: the original version failed and had to be rewritten into this!*
	"im gonna love seeing people use this for animation players"
]]

local Options = nil
local OptionsAccessories = nil
local OptionsDebug = nil
local OptionsDebugTransparency = nil
local OptionsDebugTeleportRandom = nil
local OptionsFling = nil
local OptionsDisableScripts = nil
local OptionsDisableGUIs = nil

local BindableEvent = nil
local Boolean = false
local Humanoid = nil
local Rig = nil
local RigHumanoid = nil
local RigHumanoidRootPart = nil
local Success = false
local Time = nil
local DeltaTime = nil
local LastTime = nil

local Attachments = { }
local BaseParts = { }
local Blacklist = { }
local Enableds = { }
local Highlights = { }
local RBXScriptConnections = { }
local RigAccessories = { }
local Tables = { }
local Targets = { }

local CFrame = CFrame
local CFrameAngles = CFrame.Angles
local CFrameidentity = CFrame.identity
local CFramenew = CFrame.new

local coroutine = coroutine
local coroutinecreate = coroutine.create
local coroutineclose = coroutine.close
local coroutineresume = coroutine.resume

local Enum = Enum
local HumanoidStateType = Enum.HumanoidStateType
local Physics = HumanoidStateType.Physics
local Running = HumanoidStateType.Running
local Track = Enum.CameraType.Track
local UserInputType = Enum.UserInputType
local MouseButton1 = UserInputType.MouseButton1
local Touch = UserInputType.Touch

local game = game
local Clone = game.Clone
local Destroy = game.Destroy
local FindFirstAncestorOfClass = game.FindFirstAncestorOfClass
local FindFirstChildOfClass = game.FindFirstChildOfClass
local GetPropertyChangedSignal = game.GetPropertyChangedSignal
local GetChildren = game.GetChildren
local GetDescendants = game.GetDescendants
local IsA = game.IsA
local Players = FindFirstChildOfClass(game, "Players")
local CreateHumanoidModelFromUserId = Players.CreateHumanoidModelFromUserId
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = FindFirstChildOfClass(game, "RunService")
local PostSimulation = RunService.PostSimulation
local PreRender = RunService.PreRender
local PreSimulation = RunService.PreSimulation
local Connect = PostSimulation.Connect
local Disconnect = Connect(GetPropertyChangedSignal(game, "Parent"), function() end).Disconnect
local Wait = PostSimulation.Wait
local StarterGui = FindFirstChildOfClass(game, "StarterGui")
local SetCore = StarterGui.SetCore
local UserInputService = FindFirstChildOfClass(game, "UserInputService")
local Workspace = FindFirstChildOfClass(game, "Workspace")
local CurrentCamera = Workspace.CurrentCamera

local Instancenew = Instance.new
local Humanoid = Instancenew("Humanoid")
local ApplyDescription = Humanoid.ApplyDescription
local ChangeState = Humanoid.ChangeState
local GetAppliedDescription = Humanoid.GetAppliedDescription
local Move = Humanoid.Move
Destroy(Humanoid)
local Part = Instancenew("Part")
local GetJoints = Part.GetJoints
Destroy(Part)

local math = math
local mathrandom = math.random
local mathsin = math.sin

local osclock = os.clock

local pairs = pairs
local pcall = pcall

local script = script

local stringfind = string.find

local table = table
local tableclear = table.clear
local tablefind = table.find
local tableinsert = table.insert
local tableremove = table.remove

local task = task
local taskdefer = task.defer
local taskdelay = task.delay
local taskspawn = task.spawn
local taskwait = task.wait

local sethiddenproperty = sethiddenproperty or function() end

local type = type
local typeof = typeof

local Vector3 = Vector3
local Vector3new = Vector3.new
local Vector3yAxis = Vector3.yAxis
local Vector3zero = Vector3.zero

local CameraCFrame = CFrameidentity

local LimbSize = Vector3new(1, 2, 1)
local TorsoSize = Vector3new(2, 2, 1)
local Vector314 = Vector3new(16384, 16384, 16384)

local function BreakJoints(Parent)
	for _, Instance in pairs(GetDescendants(Parent)) do
		if IsA(Instance, "JointInstance") then
			Destroy(Instance)
		end
	end
end

local function CameraSubject()
	CurrentCamera.CameraSubject = RigHumanoid
	Wait(PreRender)
	CurrentCamera.CFrame = CameraCFrame
end

local function CameraType()
	if CurrentCamera.CameraType ~= Track then
		CurrentCamera.CameraType = Track
	end
end

local function Camera()
	local Camera = Workspace.CurrentCamera

	if Camera then
		CameraCFrame = Camera.CFrame
		CurrentCamera = Camera

		CameraSubject()
		CameraType()

		tableinsert(RBXScriptConnections, Connect(GetPropertyChangedSignal(Camera, "CameraSubject"), CameraSubject))
		tableinsert(RBXScriptConnections, Connect(GetPropertyChangedSignal(Camera, "CameraType"), CameraType))
	end
end

local function FindFirstChildOfClassAndName(Parent, ClassName, Name)
	for Index, Instance in pairs(GetChildren(Parent)) do
		if IsA(Instance, ClassName) and Instance.Name == Name then
			return Instance
		end
	end
end

local function WaitForChildOfClassAndName(Parent, ...)
	local Instance = FindFirstChildOfClassAndName(Parent, ...)

	while not Instance and typeof(Parent) == "Instance" do
		Instance = FindFirstChildOfClassAndName(Parent, ...)
		Wait(Parent.ChildAdded)
	end

	return Instance
end

local function Invisible(Instance)
	if IsA(Instance, "BasePart") or IsA(Instance, "Decal") then
		Instance.Transparency = OptionsDebugTransparency
	elseif IsA(Instance, "ForceField") or IsA(Instance, "Explosion") then
		Instance.Visible = false
	elseif IsA(Instance, "ParticleEmitter") or IsA(Instance, "Fire") or IsA(Instance, "Sparkles") then
		Instance.Enabled = false
	end
end

local function DescendantAdded(Instance)
	if IsA(Instance, "Attachment") then
		local Handle = Instance.Parent

		if IsA(Handle, "BasePart") then
			local AttachmentsAttachment = Attachments[Instance.Name]

			if AttachmentsAttachment then
				local MeshId = ""
				local TextureId = ""

				if IsA(Handle, "MeshPart") then
					MeshId = Handle.MeshId
					TextureId = Handle.TextureID
				else
					local SpecialMesh = FindFirstChildOfClass(Handle, "SpecialMesh")

					if SpecialMesh then
						MeshId = SpecialMesh.MeshId
						TextureId = SpecialMesh.TextureId
					end
				end

				for Index, Table in pairs(OptionsAccessories) do
					if stringfind(MeshId, Table.MeshId) and stringfind(TextureId, Table.TextureId) then
						local Instance = FindFirstChildOfClassAndName(Rig, "BasePart", Table.Name)
						
						local AlternativeName = Table.AlternativeName
						local AlternativeInstance = false
						
						if not Instance and AlternativeName then
							Instance = FindFirstChildOfClassAndName(Rig, "BasePart", AlternativeName)
							AlternativeInstance = true
						end
						
						if Instance and not tablefind(Blacklist, Instance) then
							if Table.Blacklist then
								tableinsert(Blacklist, Instance)
							end
							BreakJoints(Handle)
							tableinsert(Tables, { Part0 = Handle, Part1 = Instance, CFrame = AlternativeInstance and Table.AllowAlternativeCFrame and Table.AlternativeCFrame or Table.CoordinateFrame, LastPosition = Instance.Position })
							return
						end
					end
				end
				for Index, Table in pairs(RigAccessories) do
					local TableHandle = Table.Handle

					if typeof(TableHandle) == "Instance" and Table.MeshId == MeshId and Table.TextureId == TextureId then
						BreakJoints(Handle)
						tableinsert(Tables, { Part0 = Handle, Part1 = TableHandle, LastPosition = TableHandle.Position })
						return
					end
				end

				local Accessory = Handle.Parent

				if IsA(Accessory, "Accessory") then
					local AccessoryClone = Instancenew("Accessory")
					AccessoryClone.Name = Accessory.Name

					local HandleClone = Clone(Handle)
					Invisible(HandleClone)
					BreakJoints(HandleClone)
					HandleClone.Parent = AccessoryClone

					local Weld = Instancenew("Weld")
					Weld.Name = "AccessoryWeld"
					Weld.C0 = Instance.CFrame
					Weld.C1 = AttachmentsAttachment.CFrame
					Weld.Part0 = HandleClone
					Weld.Part1 = AttachmentsAttachment.Parent
					Weld.Parent = HandleClone

					tableinsert(RigAccessories, { Handle = HandleClone, MeshId = MeshId, TextureId = TextureId })
					tableinsert(Tables, { Part0 = Handle, Part1 = HandleClone, LastPosition = HandleClone.Position })

					AccessoryClone.Parent = Rig
				end
			end
		end
	elseif IsA(Instance, "BasePart") then
		Instance.CanQuery = false
		tableinsert(BaseParts, Instance)
	end
end

local function ApplyDescriptionRig()
	local Description = GetAppliedDescription(Humanoid)
	Description.HatAccessory = ""
	Description.BackAccessory = ""
	Description.FaceAccessory = ""
	Description.HairAccessory = ""
	Description.NeckAccessory = ""
	Description.FrontAccessory = ""
	Description.WaistAccessory = ""
	Description.ShouldersAccessory = ""
	ApplyDescription(RigHumanoid, Description)
	
	for Index, Instance in pairs(GetDescendants(Rig)) do
		Invisible(Instance)
	end
end

local function CharacterAdded()
	local Character = LocalPlayer.Character

	if Character and Character ~= Rig then
		tableclear(BaseParts)
		tableclear(Blacklist)
		tableclear(Tables)

		if CurrentCamera then
			CameraCFrame = CurrentCamera.CFrame
		end

		for Index, Instance in pairs(GetDescendants(Character)) do
			DescendantAdded(Instance)
		end

		tableinsert(RBXScriptConnections, Connect(Character.DescendantAdded, DescendantAdded))

		Humanoid = WaitForChildOfClassAndName(Character, "Humanoid", "Humanoid")
		local HumanoidRootPart = WaitForChildOfClassAndName(Character, "BasePart", "HumanoidRootPart")

		if Boolean then
			Camera()

			if HumanoidRootPart then
				RigHumanoidRootPart.CFrame = HumanoidRootPart.CFrame
				Boolean = false
			end

			if RigHumanoid and Humanoid then
				pcall(ApplyDescriptionRig)
			end
		end

		if HumanoidRootPart then
			for Index, Table in pairs(Targets) do
				if not HumanoidRootPart then
					break
				end

				if Humanoid then
					ChangeState(Humanoid, Physics)
				end

				local Target = Table.Target

				local Timeout = Time + 0.5
				local LastPosition = Target.Position

				while Target and HumanoidRootPart do
					if Time > Timeout then
						break
					end

					local Position = Target.Position
					local LinearVelocity = ( Position - LastPosition ) / DeltaTime

					if LinearVelocity.Magnitude > 50 then
						break
					end

					LastPosition = Position

					HumanoidRootPart.AssemblyAngularVelocity = Vector314
					HumanoidRootPart.AssemblyLinearVelocity = Vector314

					HumanoidRootPart.CFrame = Target.CFrame * CFramenew(0, 0, 4 * mathsin(Time * 30)) * CFrameAngles(mathrandom(- 360, 360), mathrandom(- 360, 360), mathrandom(- 360, 360)) + ( LinearVelocity * 0.5) 
					taskwait()
				end

				local Highlight = Table.Highlight

				if Highlight then
					Destroy(Highlight)
				end

				Targets[Index] = nil
			end

			if Humanoid then
				ChangeState(Humanoid, Running)
			end

			if RigHumanoidRootPart then
				HumanoidRootPart.AssemblyAngularVelocity = Vector3zero
				HumanoidRootPart.AssemblyLinearVelocity = Vector3zero

				HumanoidRootPart.CFrame = RigHumanoidRootPart.CFrame + ( OptionsDebugTeleportRandom and Vector3new(mathrandom(- 16, 16), 0, mathrandom(- 16, 16)) or Vector3zero )
			end
		end

		taskwait(0.26 + Wait(PreSimulation))

		if Character then
			BreakJoints(Character)
		end
	end
end

local function PostSimulationConnect()
	sethiddenproperty(LocalPlayer, "SimulationRadius", 2147483647)

	Time = osclock()
	DeltaTime = Time - LastTime
	LastTime = Time

	local Integer = 29 + mathsin(Time)
	local Vector3 = Vector3new(0, 0, 0.002 * mathsin(Time * 25))

	for Index, Table in pairs(Tables) do
		local Part0 = Table.Part0
		local Part1 = Table.Part1

		if Part0 and # GetJoints(Part0) == 0 and Part0.ReceiveAge == 0 and Part1 then
			Part0.AssemblyAngularVelocity = Vector3zero

			local Position = Part1.Position
			local LinearVelocity = ( ( Table.LastPosition - Position ) / DeltaTime ) * Integer
			Table.LastPosition = Position

			Part0.AssemblyLinearVelocity = Vector3new(LinearVelocity.X, Integer, LinearVelocity.Z)

			Part0.CFrame = Part1.CFrame * ( Table.CFrame or CFrameidentity ) + Vector3
		end
	end

	if RigHumanoid and Humanoid then
		RigHumanoid.Jump = Humanoid.Jump
		Move(RigHumanoid, Humanoid.MoveDirection)
	end

	if not Success then
		Success = pcall(SetCore, StarterGui, "ResetButtonCallback", BindableEvent)
	else
		SetCore(StarterGui, "ResetButtonCallback", BindableEvent)
	end
end

local function PreSimulationConnect()
	for Index, BasePart in pairs(BaseParts) do
		BasePart.CanCollide = false
	end
end

local function Fling(Target)
	if typeof(Target) == "Instance" then
		if IsA(Target, "Humanoid") then
			Target = Target.Parent
		end
		if IsA(Target.Parent, "Accessory") then
			Target = FindFirstAncestorOfClass(Target, "Model")
		end
		if IsA(Target, "Model") then
			Target = FindFirstChildOfClassAndName(Target, "BasePart", "HumanoidRootPart")
		end
		if IsA(Target, "BasePart") then
			for Index, Table in pairs(Targets) do
				if Table.Target == Target then
					return
				end
			end

			local Parent = Target.Parent
			local Highlight = Instancenew("Highlight")
			Highlight.Adornee = Parent
			Highlight.Parent = Parent

			tableinsert(Highlights, Highlight)
			tableinsert(Targets, {Highlight = Highlight, Target = Target})
		end
	end
end

local function InputBegan(InputObject)
	local UserInputType = InputObject.UserInputType

	if UserInputType == MouseButton1 or UserInputType == Touch then
		local Target = Mouse.Target

		if Target and not Target.Anchored then
			local Model = Target.Parent

			if IsA(Model, "Model") and FindFirstChildOfClass(Model, "Humanoid") then
				local HumanoidRootPart = FindFirstChildOfClassAndName(Model, "BasePart", "HumanoidRootPart")

				if HumanoidRootPart then
					Fling(HumanoidRootPart)
				end
			else
				Fling(Target)
			end
		end
	end
end

local function Enabled(Instance)
	Enableds[Instance] = Instance.Enabled
	Instance.Enabled = false
end

local function gameDescendantAdded(Instance)
	if ( OptionsDisableGUIs and IsA(Instance, "ScreenGui") ) or ( OptionsDisableScripts and Instance ~= script and ( IsA(Instance, "LocalScript") or IsA(Instance, "Script") ) ) then
		Enableds[Instance] = Instance.Enabled
		Instance.Enabled = false

		tableinsert(RBXScriptConnections, Connect(GetPropertyChangedSignal(Instance, "Enabled"), function()
			Enableds[Instance] = Instance.Enabled
			Instance.Enabled = false
		end))
	end
end

local function Stop()
	for Index, RBXScriptConnection in pairs(RBXScriptConnections) do
		Disconnect(RBXScriptConnection)
	end
	for Index, Highlight in pairs(Highlights) do
		Destroy(Highlight)
	end
	for Instance, Boolean in pairs(Enableds) do
		Instance.Enabled = Boolean
	end

	tableclear(Attachments)
	tableclear(BaseParts)
	tableclear(Enableds)
	tableclear(Highlights)
	tableclear(RBXScriptConnections)
	tableclear(Tables)
	tableclear(Targets)

	if Rig then
		Destroy(Rig)
	end

	Destroy(BindableEvent)
	SetCore(StarterGui, "ResetButtonCallback", true)
end

local Emperean = {
	Stop = Stop,
	Start = function(Table)
		Options = Table or { }
		OptionsAccessories = Table.Accessories or { }
		OptionsDebug = Options.Debug or { }
		OptionsDebugTransparency = OptionsDebug.Transparency or 1
		OptionsDebugTeleportRandom = OptionsDebug.TeleportRandom
		OptionsFling = Options.Fling or false
		OptionsDisableScripts = Options.DisableScripts or false
		OptionsDisableGUIs = Options.DisableGUIs or false

		if OptionsDisableScripts or OptionsDisableGUIs then
			for Index, Instance in pairs(GetDescendants(game)) do
				gameDescendantAdded(Instance)
			end

			tableinsert(RBXScriptConnections, Connect(game.DescendantAdded, gameDescendantAdded))
		end

		Boolean = true
		LastTime = osclock()

		Rig = Options.R15 and CreateHumanoidModelFromUserId(Players, 5532894300) or CreateHumanoidModelFromUserId(Players, 5532891747)
		Rig.Name = LocalPlayer.Name
		RigHumanoid = Rig.Humanoid
		RigHumanoidRootPart = Rig.HumanoidRootPart
		Rig.Parent = Workspace

		for Index, Instance in pairs(GetDescendants(Rig)) do
			if IsA(Instance, "Attachment") then
				Attachments[Instance.Name] = Instance
			else
				Invisible(Instance)
			end
		end

		BindableEvent = Instancenew("BindableEvent")
		Connect(BindableEvent.Event, Stop)

		tableinsert(RBXScriptConnections, Connect(GetPropertyChangedSignal(Workspace, "CurrentCamera"), Camera))

		CharacterAdded()
		tableinsert(RBXScriptConnections, Connect(GetPropertyChangedSignal(LocalPlayer, "Character"), CharacterAdded))

		if OptionsFling then
			tableinsert(RBXScriptConnections, Connect(UserInputService.InputBegan, InputBegan))
		end

		tableinsert(RBXScriptConnections, Connect(PreSimulation, PreSimulationConnect))
		tableinsert(RBXScriptConnections, Connect(PostSimulation, PostSimulationConnect))

		return { 
			Rig = Rig,
			Options = Options,
			Fling = Fling,
		},
		taskwait()
	end,
}

if ( RunService:IsClient() and not RunService:IsStudio() ) or ( script and IsA(script, "ModuleScript") or false ) then
	return Emperean
end

Emperean.Start({
	Accessories = {
		--[[
		https://www.roblox.com/catalog/14532301415/1x1x1x1-s-Torso
		]]
		{ Blacklist = true, Name = "Torso", AlternativeName = "UpperTorso", MeshId = "14413791480", TextureId = "14413794823", AllowAlternativeCFrame = false, CoordinateFrame = CFrameidentity, AlternativeCFrame = CFrameidentity },
		
		--[[
		Resized Hats:
		Wear this head for it to work: https://www.roblox.com/catalog/2493588193/Knights-of-Redcliff-Paladin-Head
		https://www.roblox.com/catalog/12867841874/Tall-Rectangle-Head-Dark-Grey
		https://www.roblox.com/catalog/12867846420/Tall-Rectangle-Head-Grey
		https://www.roblox.com/catalog/12867904652/Light-Grey-Smiley-Rectangle-Head
		https://www.roblox.com/catalog/12867898930/Grey-Smiley-Rectangle-Head
		]]

		{ Blacklist = true, Name = "Right Arm", AlternativeName = "RightLowerArm", MeshId = "12867814848", TextureId = "12794084950", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(0, 0, 0), AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Left Arm", AlternativeName = "LeftLowerArm", MeshId = "12867814848", TextureId = "12867874342", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(0, - 1.57, 0), AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Right Leg", AlternativeName = "RightLowerLeg", MeshId = "12867814848", TextureId = "12867873138", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(0, 1.57, 0), AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Left Leg", AlternativeName = "LeftLowerLeg", MeshId = "12867814848", TextureId = "12794082919", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(0, 0, 0), AlternativeCFrame = CFrameidentity },

		--[[
		Alternative limbs:
		( Don't wear the previous head )
		https://www.roblox.com/catalog/12344591101/Extra-Right-hand-moving-Blocky-white
		https://www.roblox.com/catalog/12344545199/Extra-Left-hand-moving-Blocky-white
		https://www.roblox.com/catalog/11159410305/Rectangle-Head-For-Headless
		https://www.roblox.com/catalog/11263254795/Dummy-Head-For-Headless
		]]

		{ Blacklist = true, Name = "Right Arm", AlternativeName = "RightLowerArm", MeshId = "12344206657", TextureId = "12344206675", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(- 2, 0, 0), AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Left Arm", AlternativeName = "LeftLowerArm", MeshId = "12344207333", TextureId = "12344207341", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(- 2, 0, 0), AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Right Leg", AlternativeName = "RightLowerLeg", MeshId = "11263221350", TextureId = "11263219250", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(1.57, - 1.57, 0), AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Left Leg", AlternativeName = "LeftLowerLeg", MeshId = "11159370334", TextureId = "11159284657", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(1.57, 1.57, 0), AlternativeCFrame = CFrameidentity },

		--[[
		Free Rig:
		https://www.roblox.com/catalog/4819740796/Robox
		https://www.roblox.com/catalog/4391384843/International-Fedora-Russia
		https://www.roblox.com/catalog/4154538250/International-Fedora-Chile
		https://www.roblox.com/catalog/4094878701/International-Fedora-Mexico
		https://www.roblox.com/catalog/4489239608/International-Fedora-United-Kingdom
		]]

		{ Blacklist = true, Name = "Torso", AlternativeName = "UpperTorso", MeshId = "4819720316", TextureId = "4819722776", AllowAlternativeCFrame = false, CoordinateFrame = CFrameidentity, AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Right Arm", AlternativeName = "RightLowerArm", MeshId = "4324138105", TextureId = "4391374782", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(1.57, 1.57, 0), AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Left Arm", AlternativeName = "LeftLowerArm", MeshId = "4154474745", TextureId = "4154474807", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(1.57, 1.57, 0), AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Right Leg", AlternativeName = "RightLowerLeg", MeshId = "4094864753", TextureId = "4094881938", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(1.57, 1.57, 0), AlternativeCFrame = CFrameidentity },
		{ Blacklist = true, Name = "Left Leg", AlternativeName = "LeftLowerLeg", MeshId = "4489232754", TextureId = "4489233876", AllowAlternativeCFrame = false, CoordinateFrame = CFrameAngles(1.57, 1.57, 0), AlternativeCFrame = CFrameidentity },
	},
	Debug = {
		Transparency = 1,
		TeleportRandom = false
	},
	R15 = false,
	Fling = true,
	DisableScripts = false,
	DisableGUIs = true,
})	

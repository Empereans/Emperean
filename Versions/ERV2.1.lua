--[[
	/ Emperean Reanimate V2.1
	/ made by: emperss#0
	/ join: discord.gg/5PMtk6PJf5
	/ dont steal or change credits
	"200 variables limit when? never cuz ur supposed to use it in a loadstring"
]]

local Options = nil
local OptionsAccessories = nil
local OptionsDebug = nil
local OptionsDebugTransparency = nil
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

local LocalPlayer = FindFirstChildOfClass(game, "Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

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

local Model = Instancenew("Model")

local function Part(Name, Size)
	local Part = Instancenew("Part")
	Part.Name = Name
	Part.Size = Size
	Part.Parent = Model

	return Part
end

local function Motor6D(Name, C0, C1, Part0, Part1)
	local Motor6D = Instancenew("Motor6D")
	Motor6D.Name = Name
	Motor6D.C0 = C0
	Motor6D.C1 = C1
	Motor6D.Part0 = Part0
	Motor6D.Part1 = Part1
	Motor6D.Parent = Part0

	return Motor6D
end

local function Attachment(Name, CFrame, Parent)
	local Attachment = Instancenew("Attachment")
	Attachment.Name = Name
	Attachment.CFrame = CFrame
	Attachment.Parent = Parent

	return Attachment
end

local Head = Part("Head", Vector3new(2, 1, 1))
local GetJoints = Head.GetJoints
local Torso = Part("Torso", TorsoSize)
local LeftArm = Part("Left Arm", LimbSize)
local RightArm = Part("Right Arm", LimbSize)
local LeftLeg = Part("Left Leg", LimbSize)
local RightLeg = Part("Right Leg", LimbSize)
local HumanoidRootPart = Part("HumanoidRootPart", TorsoSize)

Motor6D("Right Shoulder", CFramenew(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0), CFramenew(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0), Torso, RightArm)
Motor6D("Left Shoulder", CFramenew(-1, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0), CFramenew(0.5, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0), Torso, LeftArm)
Motor6D("Right Hip", CFramenew(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0), CFramenew(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0), Torso, RightLeg)
Motor6D("Left Hip", CFramenew(-1, -1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0), CFramenew(-0.5, 1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0), Torso, LeftLeg)
Motor6D("Neck", CFramenew(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0), CFramenew(0, -0.5, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0), Torso, Head)
Motor6D("RootJoint", CFramenew(0, 0, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0), CFramenew(0, 0, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0), HumanoidRootPart, Torso)

Attachment("HairAttachment", CFramenew(0, 0.600000024, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Head)
Attachment("HatAttachment", CFramenew(0, 0.600000024, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Head)
Attachment("FaceFrontAttachment", CFramenew(0, 0, -0.600000024, 1, 0, 0, 0, 1, 0, 0, 0, 1), Head)
Attachment("FaceCenterAttachment", CFramenew(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Head)
Attachment("NeckAttachment", CFramenew(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("BodyFrontAttachment", CFramenew(0, 0, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("BodyBackAttachment", CFramenew(0, 0, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("LeftCollarAttachment", CFramenew(-1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("RightCollarAttachment", CFramenew(1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("WaistFrontAttachment", CFramenew(0, -1, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("WaistCenterAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("WaistBackAttachment", CFramenew(0, -1, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("LeftShoulderAttachment", CFramenew(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), LeftArm)
Attachment("LeftGripAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), LeftArm)
Attachment("RightShoulderAttachment", CFramenew(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), RightArm)
Attachment("RightGripAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), RightArm)
Attachment("LeftFootAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), LeftLeg)
Attachment("RightFootAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), RightLeg)
Attachment("RootAttachment", CFramenew(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), HumanoidRootPart)

Instancenew("BodyColors", Model)
local Humanoid = Instancenew("Humanoid", Model)
local ChangeState = Humanoid.ChangeState
local Move = Humanoid.Move
Instancenew("Animator", Humanoid)

local face = Instancenew("Decal")
face.Name = "face"
face.Texture = "rbxasset://textures/face.png"
face.Parent = Head

local SpecialMesh = Instancenew("SpecialMesh")
SpecialMesh.Name = "Mesh"
SpecialMesh.MeshType = Enum.MeshType.Head
SpecialMesh.Scale = Vector3new(1.25, 1.25, 1.25)
SpecialMesh.Parent = Head

Instancenew("Shirt", Model)
Instancenew("Pants", Model)
Instancenew("ShirtGraphic", Model)

local Animate = Instancenew("LocalScript")
Animate.Name = "Animate"
Animate.Enabled = true
Animate.Parent = Model

Model.Name = LocalPlayer.Name

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

						if Instance and not tablefind(Blacklist, Instance) then
							tableinsert(Blacklist, Instance)
							BreakJoints(Handle)
							tableinsert(Tables, { Part0 = Handle, Part1 = Instance, CFrame = Table.CoordinateFrame, LastPosition = Instance.Position })
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
		taskdelay(1, BreakJoints, Instance)
	end
end

local function ApplyDescription()
	local Description = Humanoid:GetAppliedDescription()
	Description.HatAccessory = ""
	Description.BackAccessory = ""
	Description.FaceAccessory = ""
	Description.HairAccessory = ""
	Description.NeckAccessory = ""
	Description.FrontAccessory = ""
	Description.WaistAccessory = ""
	Description.ShouldersAccessory = ""
	RigHumanoid:ApplyDescription(Description)
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
				pcall(ApplyDescription)
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

				HumanoidRootPart.CFrame = RigHumanoidRootPart.CFrame + Vector3new(mathrandom(- 16, 16), 0, mathrandom(- 16, 16))
			end
		end

		taskwait(0.26)

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
	local Vector3 = Vector3new(0, 0, 0.001 * mathsin(Time * 20))

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
			Target = FindFirstAncestorOfClass(Target, "BasePart", "HumanoidRootPart")
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

		Rig = Clone(Model)
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
		{ Name = "Torso", MeshId = "14413791480", TextureId = "14413794823", CoordinateFrame = CFrameidentity },

		--[[
		Resized Hats:
		Wear this head for it to work: https://www.roblox.com/catalog/2493588193/Knights-of-Redcliff-Paladin-Head
		https://www.roblox.com/catalog/12867841874/Tall-Rectangle-Head-Dark-Grey
		https://www.roblox.com/catalog/12867846420/Tall-Rectangle-Head-Grey
		https://www.roblox.com/catalog/12867904652/Light-Grey-Smiley-Rectangle-Head
		https://www.roblox.com/catalog/12867898930/Grey-Smiley-Rectangle-Head
		]]

		{ Name = "Right Arm", MeshId = "12867814848", TextureId = "12794084950", CoordinateFrame = CFrameAngles(0, 0, 0) },
		{ Name = "Left Arm", MeshId = "12867814848", TextureId = "12867874342", CoordinateFrame = CFrameAngles(0, - 1.57, 0) },
		{ Name = "Right Leg", MeshId = "12867814848", TextureId = "12867873138", CoordinateFrame = CFrameAngles(0, 1.57, 0) },
		{ Name = "Left Leg", MeshId = "12867814848", TextureId = "12794082919", CoordinateFrame = CFrameAngles(0, 0, 0) },

		--[[
		Alternative limbs:
		( Don't wear the previous head )
		https://www.roblox.com/catalog/12344591101/Extra-Right-hand-moving-Blocky-white
		https://www.roblox.com/catalog/12344545199/Extra-Left-hand-moving-Blocky-white
		https://www.roblox.com/catalog/11159410305/Rectangle-Head-For-Headless
		https://www.roblox.com/catalog/11263254795/Dummy-Head-For-Headless
		]]

		{ Name = "Right Arm", MeshId = "12344206657", TextureId = "12344206675", CoordinateFrame = CFrameAngles(- 2, 0, 0) },
		{ Name = "Left Arm", MeshId = "12344207333", TextureId = "12344207341", CoordinateFrame = CFrameAngles(- 2, 0, 0) },
		{ Name = "Right Leg", MeshId = "11263221350", TextureId = "11263219250", CoordinateFrame = CFrameAngles(1.57, - 1.57, 0) },
		{ Name = "Left Leg", MeshId = "11159370334", TextureId = "11159284657", CoordinateFrame = CFrameAngles(1.57, 1.57, 0) },

		--[[
		Free Rig:
		https://www.roblox.com/catalog/4819740796/Robox
		https://www.roblox.com/catalog/4391384843/International-Fedora-Russia
		https://www.roblox.com/catalog/4154538250/International-Fedora-Chile
		https://www.roblox.com/catalog/4094878701/International-Fedora-Mexico
		https://www.roblox.com/catalog/4489239608/International-Fedora-United-Kingdom
		]]

		{ Name = "Torso", MeshId = "4819720316", TextureId = "4819722776", CoordinateFrame = CFrameidentity },
		{ Name = "Right Arm", MeshId = "4324138105", TextureId = "4391374782", CoordinateFrame = CFrameAngles(1.57, 1.57, 0) },
		{ Name = "Left Arm", MeshId = "4154474745", TextureId = "4154474807", CoordinateFrame = CFrameAngles(1.57, 1.57, 0) },
		{ Name = "Right Leg", MeshId = "4094864753", TextureId = "4094881938", CoordinateFrame = CFrameAngles(1.57, 1.57, 0) },
		{ Name = "Left Leg", MeshId = "4489232754", TextureId = "4489233876", CoordinateFrame = CFrameAngles(1.57, 1.57, 0) },
	},
	Debug = {
		Transparency = 1
	},
	Fling = true,
	DisableScripts = false,
	DisableGUIs = true,
})

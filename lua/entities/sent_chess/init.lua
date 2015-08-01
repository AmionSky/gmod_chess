AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString( 'Chess_SendPlyData' )
util.AddNetworkString( 'Chess_SendData' )
util.AddNetworkString( 'Chess_ChangePiece' )
util.AddNetworkString( 'Chess_ResetGame' )
util.AddNetworkString( 'Chess_RemoveFGame' )
util.AddNetworkString( 'Chess_MovePiece' )
util.AddNetworkString( 'Chess_Step' )

net.Receive('Chess_ResetGame', function()
	local chess = Entity(net.ReadUInt(32))
	if not IsValid(chess) then return end
	local ply = net.ReadEntity()
	if chess:GetTableOwner() != ply then return end
	if IsValid(ply) then
		local msg = "Resetting by request of " .. ply:Nick() .. " ("..ply:SteamID()..")"
		if IsValid(chess:GetPly1()) then chess:GetPly1():ChatPrint(msg) end
		if IsValid(chess:GetPly2()) then chess:GetPly2():ChatPrint(msg) end
	end
	net.Start( 'Chess_ResetGame' )
		net.WriteUInt( chess:EntIndex(), 32 )
	net.Broadcast()
	chess:StartGame()
	chess:SendData()
end )
net.Receive('Chess_MovePiece', function()
	local chess = Entity(net.ReadUInt(32))
	if not IsValid(chess) then return end
	if chess:GetTurnPly() != net.ReadEntity() then return end
	local sx = net.ReadUInt(32)
	local sy = net.ReadUInt(32)
	local mx = net.ReadUInt(32)
	local my = net.ReadUInt(32)
	if sx <= 8 and sy <= 8 and mx <= 8 and my <= 8 and sx > 0 and sy > 0 and mx > 0 and my > 0 then
		chess:MovePiece( sx, sy, mx, my )
	end
end )
net.Receive('Chess_SendData', function()
	local chess = Entity(net.ReadUInt(32))
	if not IsValid(chess) then return end
	local ply = net.ReadEntity()
	if IsValid(ply) then chess:SendData(ply) end
end )

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then return end
	local ent = ents.Create(self.ClassName)
	ent:SetPos(tr.HitPos + tr.HitNormal)
	ent:Spawn()
	return ent
end

function ENT:Initialize()
	self:SetModel("models/props/de_tides/restaurant_table.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:StartGame()
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(100)
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableMotion(false)
	end
end

function ENT:StartGame()
	self.piece = {
		["type"] = {
			[1]  = 1,
			[2]  = 2,
			[3]  = 3,
			[4]  = 4,
			[5]  = 5,
			[6]  = 3,
			[7]  = 2,
			[8]  = 1,
			[9]  = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
			[13] = 0,
			[14] = 0,
			[15] = 0,
			[16] = 0,
			[17] = 1,
			[18] = 2,
			[19] = 3,
			[20] = 4,
			[21] = 5,
			[22] = 3,
			[23] = 2,
			[24] = 1,
			[25] = 0,
			[26] = 0,
			[27] = 0,
			[28] = 0,
			[29] = 0,
			[30] = 0,
			[31] = 0,
			[32] = 0
		},
		["moved"] = {}
	}
	for i=1,32 do
		self.piece.moved[i] = false
	end
	self.brd_data = {}
	self:ResetBrdData()
end

function ENT:EndGame()
	if self:GetTableTurn() == 1 then
		if IsValid(self:GetPly1()) then self:GetPly1():ChatPrint("Win") end
		if IsValid(self:GetPly2()) then self:GetPly2():ChatPrint("Lose") end
	else
		if IsValid(self:GetPly1()) then self:GetPly1():ChatPrint("Lose") end
		if IsValid(self:GetPly2()) then self:GetPly2():ChatPrint("Win") end
	end
	self:ChangeTurn()
	self:StartGame()
end

function ENT:Use(act)
	if !act:IsPlayer() then return end
	
	local eye = act:GetEyeTrace()
	if eye.Entity != self then return end
	
	for k,v in pairs(ents.FindByClass("sent_chess")) do
		if v != self and (v:GetPly1() == act or v:GetPly2() == act) then
			return
		end
	end
	
	if act == self:GetPly1() then
		if IsValid(self:GetPly2()) then self:SetTableOwner(self:GetPly2()) end
		self:SetPly1(nil)
		self:RemoveFGame( act )
		act:ChatPrint("Removing from game")
		return
	end
	if act == self:GetPly2() then
		if IsValid(self:GetPly1()) then self:SetTableOwner(self:GetPly1()) end
		self:SetPly2(nil)
		self:RemoveFGame( act )
		act:ChatPrint("Removing from game")
		return
	end
	
	if IsValid(self:GetPly1()) and IsValid(self:GetPly2()) then act:ChatPrint("Board full") return end
	
	local pos,ang = WorldToLocal(eye.HitPos, Angle(), self:GetPos(), self:GetAngles())
	local resettext = "If you would like to reset the table press R"
	
	if pos.y > 0 then
		if not IsValid(self:GetPly1()) then
			self:SetPly1(act)
			if not IsValid(self:GetPly2()) then
				self:SetTableOwner(self:GetPly1())
				self:SetTableTurn(1)
				act:ChatPrint(resettext)
			end
			self:SendPlyData( act )
		else
			act:ChatPrint("Side full")
		end
	else
		if not IsValid(self:GetPly2()) then
			self:SetPly2(act)
			if not IsValid(self:GetPly1()) then
				self:SetTableOwner(self:GetPly2())
				self:SetTableTurn(2)
				act:ChatPrint(resettext)
			end
			self:SendPlyData( act )
		else
			act:ChatPrint("Side full")
		end
	end
end

function ENT:SendData(ply)
	net.Start( 'Chess_SendData' )
		net.WriteUInt( self:EntIndex(), 32 )
		net.WriteTable( self.brd_data )
	if IsValid(ply) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function ENT:SendStep(ch,c)
	net.Start( 'Chess_Step' )
		net.WriteUInt( self:EntIndex(), 32 )
		net.WriteBit(c)
		net.WriteTable(ch)
	net.Broadcast()
end

function ENT:ChangePiece( ind )
	net.Start( 'Chess_ChangePiece' )
		net.WriteUInt( self:EntIndex(), 32 )
		net.WriteUInt( ind, 32 )
	net.Broadcast()
end

function ENT:SendPlyData( ply )
	if IsValid(ply) then
		net.Start( 'Chess_SendPlyData' )
			net.WriteUInt( self:EntIndex(), 32 )
			net.WriteTable( self.piece.type )
			net.WriteTable( self.piece.moved )
		net.Send( ply )
	end
end

function ENT:RemoveFGame( ply )
	net.Start( 'Chess_RemoveFGame' )
		net.WriteUInt( self:EntIndex(), 32 )
	net.Send( ply )
end

function ENT:MovePiece( sx, sy, mx, my )
	local selectedind = self.brd_data[sx][sy]
	
	if selectedind == 0 then
		Error("Chess: #"..self:EntIndex().." | Incorrect step!\n")
		return
	end
	if self.brd_data[mx][my] == 4 or self.brd_data[mx][my] == 20 then
		self:EndGame()
		return
	end
	if self.piece.type[selectedind] == 0 and ( my == 1 or my == 8 ) then
		self.piece.type[selectedind] = 5
		self:ChangePiece( selectedind )
	end
	
	local ch = {}
	local c = false
	
	ch[1] = { sx,sy,0 }
	ch[2] = { mx,my,selectedind }
	self.brd_data[sx][sy] = 0
	self.brd_data[mx][my] = selectedind
	
	if self.piece.type[selectedind] == 4 and !self.piece.moved[selectedind] then
		if mx == 2 then
			if my == 8 then
				ch[3] = { 3,8,self.brd_data[1][8] }
				ch[4] = { 1,8,0 }
				//self.brd_data[3][8] = self.brd_data[1][8]
				//self.brd_data[1][8] = 0
			else
				ch[3] = { 3,1,self.brd_data[1][1] }
				ch[4] = { 1,1,0 }
			end
			c = true
		end
		if mx == 6 then
			if my == 8 then
				ch[3] = { 5,8,self.brd_data[8][8] }
				ch[4] = { 8,8,0 }
			else
				ch[3] = { 5,1,self.brd_data[8][1] }
				ch[4] = { 8,1,0 }
			end
			c = true
		end
	end
	
	local m = 2
	if c then m = 4 end
	
	self:SendStep(ch,c)
	self:ChangeStep(ch,m)
	self:SendPlyData( self:GetPly1() )
	self:SendPlyData( self:GetPly2() )
	self:ChangeTurn()
end

function ENT:ChangeTurn()
	if self:GetTableTurn() == 1 then
		self:SetTableTurn(2)
	else
		self:SetTableTurn(1)
	end
end

function ENT:Think()
	local msg = "Too far from board, kicked!"
	if IsValid(self:GetPly1()) then
		if(self:GetPly1():GetPos():Distance(self:GetPos()) > 200) then
			self:GetPly1():ChatPrint(msg)
			if self:GetTableOwner() == self:GetPly1() then self:SetTableOwner(self:GetPly2()) end
			self:SetPly1(nil)
		end
	end
	if IsValid(self:GetPly2()) then
		if(self:GetPly2():GetPos():Distance(self:GetPos()) > 200) then
			self:GetPly2():ChatPrint(msg)
			if self:GetTableOwner() == self:GetPly2() then self:SetTableOwner(self:GetPly1()) end
			self:SetPly2(nil)
		end
	end
end

function ENT:OnRemove()
end
include('shared.lua')
include('rules.lua')

local brdpos = {
	["x"] = {
		[1] = -14.7,
		[2] = -10.5,
		[3] = -6.3,
		[4] = -2.1,
		[5] = 2.1,
		[6] = 6.3,
		[7] = 10.5,
		[8] = 14.7
	},
	["y"] = {
		[1] = -14.45,
		[2] = -10.3,
		[3] = -6.15,
		[4] = -2,
		[5] = 2.25,
		[6] = 6.4,
		[7] = 10.55,
		[8] = 14.7
	}
}
local rectpos = {
	["x"] = {
		[1] = -20,
		[2] = -15,
		[3] = -10,
		[4] = -5,
		[5] = 0,
		[6] = 5,
		[7] = 10,
		[8] = 15
	},
	["y"] = {
		[1] = 15,
		[2] = 10,
		[3] = 5,
		[4] = 0,
		[5] = -5,
		[6] = -10,
		[7] = -15,
		[8] = -20
	}
}
local mdlsize = {
	[1] = 0.13,
	[2] = 0.22
}
local ChessModels = {
		[1] = "models/props_phx/games/chess/white_rook.mdl",
		[2] = "models/props_phx/games/chess/white_knight.mdl",
		[3] = "models/props_phx/games/chess/white_bishop.mdl",
		[4] = "models/props_phx/games/chess/white_king.mdl",
		[5] = "models/props_phx/games/chess/white_queen.mdl",
		[6] = "models/props_phx/games/chess/white_pawn.mdl",
		[7] = "models/props_phx/games/chess/black_rook.mdl",
		[8] = "models/props_phx/games/chess/black_knight.mdl",
		[9] = "models/props_phx/games/chess/black_bishop.mdl",
		[10] = "models/props_phx/games/chess/black_king.mdl",
		[11] = "models/props_phx/games/chess/black_queen.mdl",
		[12] = "models/props_phx/games/chess/black_pawn.mdl"
}

surface.CreateFont( "ChessGameFontPlayer", {
	font 		= "Default",
	size 		= 30,
	weight 		= 450,
	antialias 	= true,
	additive 	= false,
	shadow 		= false,
	outline 	= false
} )

net.Receive('Chess_Game', function()
	local chess = Entity(net.ReadUInt(32))
	local cmd = net.ReadUInt(4)
	if not IsValid(chess) then return end
	if		cmd == 1 then
		chess.brd_data = net.ReadTable()
	elseif	cmd == 2 then
		chess:ChangeStep(net.ReadTable(),net.ReadBool())
	elseif	cmd == 3 then
		chess:ChangePiece(net.ReadUInt(7))
	elseif	cmd == 4 then
		chess:SendPlyData(net.ReadTable(),net.ReadTable())
	elseif	cmd == 5 then
		hook.Remove( "KeyPress", chess )
	elseif	cmd == 6 then
		chess:ResetGameCl()
	end
end)

function ENT:SendPlyData(t_type,t_moved)
	self.piece.type = t_type
	self.piece.moved = t_moved
	self.sel = { ["x"] = 0, ["y"] = 0 }
	self.look = { ["x"] = 0, ["y"] = 0 }
	self:ResetAvailable()
	self:AddHooks()
	self:CheckKing()
end
function ENT:ChangePiece(ind)
	if self.mdls and self.mdls.piece and IsValid(self.mdls.piece[ind]) then
		self.piece.type[ind] = 5
		self.mdls.piece[ind]:Remove()
		if ind <= 16 then
			self.mdls.piece[ind] = ClientsideModel(ChessModels[5], RENDERGROUP_OPAQUE)
		else
			self.mdls.piece[ind] = ClientsideModel(ChessModels[11], RENDERGROUP_OPAQUE)
		end
		self.mdls.piece[ind]:SetNoDraw(true)
		self.mdls.piece[ind]:SetPos(self:GetPos())
		local mat = Matrix()
		mat:Scale(Vector(mdlsize[2], mdlsize[2], mdlsize[2]))
		self.mdls.piece[ind]:EnableMatrix("RenderMultiply", mat)
	end
end

function ENT:Initialize()
	self.available = {}
	self.brd_data = {}
	self.sel = { ["x"] = 0, ["y"] = 0 }
	self.look = { ["x"] = 0, ["y"] = 0 }
	self.kwarn = { ["x"] = 0, ["y"] = 0 }
	self.piece = {
		["type"] = {},
		["moved"] = {}
	}
	self:ResetBrdData()
	
	net.Start( 'Chess_Game' )
		net.WriteUInt( self:EntIndex(), 32 )
		net.WriteUInt( 0, 3 )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

function ENT:AddHooks()
	local last_time = RealTime() - 3
	hook.Add("KeyPress", self, function(self, ply, key)
		if not IsValid(self) then return end
		if key == IN_RELOAD and self:GetPly(self:GetTableOwner()) == ply and RealTime() - last_time > 3 then
			net.Start( 'Chess_Game' )
				net.WriteUInt( self:EntIndex(), 32 )
				net.WriteUInt( 1, 3 )
				net.WriteEntity( LocalPlayer() )
			net.SendToServer()
			last_time = RealTime()
		end
		if key == IN_ATTACK and self:GetPly(self:GetTableTurn()) == ply and self.look.x != 0 and self.look.y != 0 then
			if self.available[self.look.x][self.look.y] then
				self:MovePiece(self.look.x,self.look.y)
			else
				if self.brd_data[self.look.x][self.look.y] != 0 then
					self:CheckPiece( self.look.x, self.look.y )
				end
			end
		end
	end)
end

function ENT:CreateModels()
	self.mdls = {}
	self.mdls.brd = ClientsideModel("models/props_phx/games/chess/board.mdl", RENDERGROUP_OPAQUE)
	self.mdls.brd:SetNoDraw(true)
	self.mdls.brd:SetPos(self:GetPos())
	local matbrd = Matrix()
	matbrd:Scale(Vector(mdlsize[1], mdlsize[1], mdlsize[1]))
	self.mdls.brd:EnableMatrix("RenderMultiply", matbrd)
	self:CreatePieceModels()
end

function ENT:CreatePieceModels()
	self.mdls.piece = {
		[1]  = ClientsideModel(ChessModels[1], RENDERGROUP_OPAQUE),
		[2]  = ClientsideModel(ChessModels[2], RENDERGROUP_OPAQUE),
		[3]  = ClientsideModel(ChessModels[3], RENDERGROUP_OPAQUE),
		[4]  = ClientsideModel(ChessModels[4], RENDERGROUP_OPAQUE),
		[5]  = ClientsideModel(ChessModels[5], RENDERGROUP_OPAQUE),
		[6]  = ClientsideModel(ChessModels[3], RENDERGROUP_OPAQUE),
		[7]  = ClientsideModel(ChessModels[2], RENDERGROUP_OPAQUE),
		[8]  = ClientsideModel(ChessModels[1], RENDERGROUP_OPAQUE),
		[9]  = ClientsideModel(ChessModels[6], RENDERGROUP_OPAQUE),
		[10] = ClientsideModel(ChessModels[6], RENDERGROUP_OPAQUE),
		[11] = ClientsideModel(ChessModels[6], RENDERGROUP_OPAQUE),
		[12] = ClientsideModel(ChessModels[6], RENDERGROUP_OPAQUE),
		[13] = ClientsideModel(ChessModels[6], RENDERGROUP_OPAQUE),
		[14] = ClientsideModel(ChessModels[6], RENDERGROUP_OPAQUE),
		[15] = ClientsideModel(ChessModels[6], RENDERGROUP_OPAQUE),
		[16] = ClientsideModel(ChessModels[6], RENDERGROUP_OPAQUE),
		[17] = ClientsideModel(ChessModels[7], RENDERGROUP_OPAQUE),
		[18] = ClientsideModel(ChessModels[8], RENDERGROUP_OPAQUE),
		[19] = ClientsideModel(ChessModels[9], RENDERGROUP_OPAQUE),
		[20] = ClientsideModel(ChessModels[10], RENDERGROUP_OPAQUE),
		[21] = ClientsideModel(ChessModels[11], RENDERGROUP_OPAQUE),
		[22] = ClientsideModel(ChessModels[9], RENDERGROUP_OPAQUE),
		[23] = ClientsideModel(ChessModels[8], RENDERGROUP_OPAQUE),
		[24] = ClientsideModel(ChessModels[7], RENDERGROUP_OPAQUE),
		[25] = ClientsideModel(ChessModels[12], RENDERGROUP_OPAQUE),
		[26] = ClientsideModel(ChessModels[12], RENDERGROUP_OPAQUE),
		[27] = ClientsideModel(ChessModels[12], RENDERGROUP_OPAQUE),
		[28] = ClientsideModel(ChessModels[12], RENDERGROUP_OPAQUE),
		[29] = ClientsideModel(ChessModels[12], RENDERGROUP_OPAQUE),
		[30] = ClientsideModel(ChessModels[12], RENDERGROUP_OPAQUE),
		[31] = ClientsideModel(ChessModels[12], RENDERGROUP_OPAQUE),
		[32] = ClientsideModel(ChessModels[12], RENDERGROUP_OPAQUE)
	}
	
	for k,v in pairs(self.mdls.piece) do
		v:SetNoDraw(true)
		v:SetPos(self:GetPos())
		local mat = Matrix()
		mat:Scale(Vector(mdlsize[2], mdlsize[2], mdlsize[2]))
		v:EnableMatrix("RenderMultiply", mat)
	end
end

function ENT:ResetAvailable()
	for i=1,8 do
		self.available[i] = {}
		for j=1,8 do
			self.available[i][j] = false
		end
	end
end

function ENT:ResetGameCl()
	self.sel.x = 0
	self.sel.y = 0
	self:RemovePieceModels()
	self:CreatePieceModels()
	self:ResetBrdData()
	self:ResetAvailable()
	for i=1,32 do
		self.piece.moved[i] = false
	end
	for i=9,16 do
		self.piece.type[i] = 0
	end
	for i=25,32 do
		self.piece.type[i] = 0
	end
	self.piece.type[1] = 1
	self.piece.type[2] = 2
	self.piece.type[3] = 3
	self.piece.type[4] = 4
	self.piece.type[5] = 5
	self.piece.type[6] = 3
	self.piece.type[7] = 2
	self.piece.type[8] = 1
	self.piece.type[17] = 1
	self.piece.type[18] = 2
	self.piece.type[19] = 3
	self.piece.type[20] = 4
	self.piece.type[21] = 5
	self.piece.type[22] = 3
	self.piece.type[23] = 2
	self.piece.type[24] = 1
	self.kwarn = { ["x"] = 0, ["y"] = 0 }
end

function ENT:Think()
	if LocalPlayer() != self:GetPly(self:GetTableTurn()) then return end
	
	local piecepos,pieceang = LocalToWorld(Vector(0.1, 0, 34.5), Angle(0, 180, 0), self:GetPos(), self:GetAngles())
	local vec = util.IntersectRayWithPlane(LocalPlayer():EyePos(), LocalPlayer():EyeAngles():Forward(), piecepos, pieceang:Up())
	
	if vec == nil then return end
	
	local brpos,brang = WorldToLocal(vec, Angle(), self:GetPos(), self:GetAngles())
	local posx = math.ceil( brpos.X / 4.2 + 4 )
	local posy = math.ceil( brpos.Y / 4.2 + 4 )
	
	if posx > 8 or posx < 1 or posy > 8 or posy < 1 then return end
	
	self.look.x = posx
	self.look.y = posy
end

function ENT:MovePiece(x,y)
	net.Start( 'Chess_Game' )
		net.WriteUInt( self:EntIndex(), 32 )
		net.WriteUInt( 2, 3 )
		net.WriteEntity( LocalPlayer() )
		net.WriteUInt( self.sel.x, 5 )
		net.WriteUInt( self.sel.y, 5 )
		net.WriteUInt( x, 5 )
		net.WriteUInt( y, 5 )
	net.SendToServer()
	self.sel.x = 0
	self.sel.y = 0
	self.kwarn = { ["x"] = 0, ["y"] = 0 }
	self:ResetAvailable()
end

function SetPosToChess(pos, ang, x, y, z )
	local setvector = Vector(x, y, z)
	setvector:Rotate( ang )
	local setpos = pos + setvector
	return setpos
end

function ENT:Draw()
	self:DrawModel()
	
	if not self.mdls or not IsValid(self.mdls.brd) then self:CreateModels() end
	local boardpos,boardang = LocalToWorld(Vector(0, 0, 32), Angle(-90, 0, 0), self:GetPos(), self:GetAngles())
	self.mdls.brd:SetRenderOrigin(boardpos)
	self.mdls.brd:SetRenderAngles(boardang)
	self.mdls.brd:DrawModel()
	
	if LocalPlayer():GetShootPos():Distance(self:GetPos()) > 500 then return end
	
	local piecepos,pieceang = LocalToWorld(Vector(0, 0, 34.5), Angle(0, 0, 0), self:GetPos(), self:GetAngles())
	local piecepos_w,pieceang_w = LocalToWorld(Vector(0, 0, 34.5), Angle(0, -90, 0), self:GetPos(), self:GetAngles())
	local piecepos_b,pieceang_b = LocalToWorld(Vector(0, 0, 34.5), Angle(0, 90, 0), self:GetPos(), self:GetAngles())
	for i=1,8 do
		for	j=1,8 do
			if self.brd_data[i][j] != 0 then
				local mdl = self.mdls.piece[self.brd_data[i][j]]
				mdl:SetRenderOrigin(SetPosToChess(piecepos, pieceang, brdpos.x[i], brdpos.y[j], 0 ))
				if self.brd_data[i][j] == 2 or self.brd_data[i][j] == 7 then
					mdl:SetRenderAngles(pieceang_w)
				elseif self.brd_data[i][j] == 18 or self.brd_data[i][j] == 23 then
					mdl:SetRenderAngles(pieceang_b)
				else
					mdl:SetRenderAngles(pieceang)
				end
				mdl:DrawModel()
			end
		end
	end
	
	if IsValid(self:GetPly1()) then
		local ang = self:GetAngles()
		ang:RotateAroundAxis( ang:Up(), 180 )
		cam.Start3D2D( SetPosToChess(self:GetPos(), self:GetAngles(), 0, 20, 32.3 ), ang, 0.2 )
			if self:GetTableTurn() then
				draw.DrawText( self:GetPly1():Nick(), "ChessGameFontPlayer", 0, 0, Color( 0, 255, 0 ), 1 )
			else
				draw.DrawText( self:GetPly1():Nick(), "ChessGameFontPlayer", 0, 0, Color( 255, 0, 0 ), 1 )
			end
			if self:GetTableOwner() then
				draw.DrawText("Owner", "ChessGameFontPlayer", 0, 20, Color(255, 255, 0), TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
	if IsValid(self:GetPly2()) then
		cam.Start3D2D( SetPosToChess(self:GetPos(), self:GetAngles(), 0, -20, 32.3 ), self:GetAngles(), 0.2 )
			if not self:GetTableTurn() then
				draw.DrawText( self:GetPly2():Nick(), "ChessGameFontPlayer", 0, 0, Color( 0, 255, 0 ), 1 )
			else
				draw.DrawText( self:GetPly2():Nick(), "ChessGameFontPlayer", 0, 0, Color( 255, 0, 0 ), 1 )
			end
			if not self:GetTableOwner() then
				draw.DrawText("Owner", "ChessGameFontPlayer", 0, 20, Color(255, 255, 0), TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
	
	if LocalPlayer() == self:GetPly(self:GetTableTurn()) then
		cam.Start3D2D( SetPosToChess(self:GetPos(), self:GetAngles(), 0, 0.2, 34.58 ), self:GetAngles(), 0.085 )
		if self.look.x != 0 and self.look.y != 0 then
			if ( self.brd_data[self.look.x][self.look.y] != 0 and (self:GetTableTurn() and self.brd_data[self.look.x][self.look.y] < 17) or ( not self:GetTableTurn() and self.brd_data[self.look.x][self.look.y] > 16)) then
				surface.SetDrawColor(Color(0,255,0,200))
			else
				surface.SetDrawColor(Color(255,0,0,200))
			end
			surface.DrawRect(rectpos.x[self.look.x] * 10, rectpos.y[self.look.y] * 9.8, 50, 50)
		end
		if self.sel.x != 0 and self.sel.y != 0 then
			surface.SetDrawColor(Color(0,150,0,200))
			surface.DrawRect(rectpos.x[self.sel.x] * 10, rectpos.y[self.sel.y] * 9.8, 50, 50)
			for i=1,8 do
				for j=1,8 do
					if self.available[i][j] == true then
						surface.SetDrawColor(Color(0,0,255,200))
						surface.DrawRect(rectpos.x[i] * 10, rectpos.y[j] * 9.8, 50, 50)
					end
				end
			end
		end
		if self.kwarn.x != 0 and self.kwarn.y != 0 then
			surface.SetDrawColor(Color(255,100,0,200))
			surface.DrawRect(rectpos.x[self.kwarn.x] * 10, rectpos.y[self.kwarn.y] * 9.8, 50, 50)
		end
		cam.End3D2D()
	end
end

function ENT:RemovePieceModels()
	for k,v in pairs(self.mdls.piece) do
		if v.SetNoDraw then
			v:Remove()
		end
	end
end
 
function ENT:OnRemove()
	if self.mdls.brd.SetNoDraw then
		self.mdls.brd:Remove()
	end
	self:RemovePieceModels()
	hook.Remove( "KeyPress", self )
end
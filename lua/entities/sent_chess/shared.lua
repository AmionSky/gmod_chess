ENT.Type 			= "anim"
ENT.PrintName		= "Chess"
ENT.Author			= "Pisti01"
ENT.Category 		= "Fun + Games"
ENT.ClassName		= "sent_chess"
ENT.Spawnable		= true
ENT.AdminSpawnable	= false

function ENT:SetupDataTables()
	self:NetworkVar("Entity" , 0, "Ply1")
	self:NetworkVar("Entity" , 1, "Ply2")
	self:NetworkVar("Entity" , 2, "TableOwner")
	self:NetworkVar("Int", 0, "TableTurn")
end

function ENT:ResetBrdData()
	for i=1,8 do
		self.brd_data[i] = {}
		for j=1,8 do
			self.brd_data[i][j] = 0
		end
		self.brd_data[i][8]=i
		self.brd_data[i][7]=i+8
		self.brd_data[i][1]=i+16
		self.brd_data[i][2]=i+24
	end
end

function ENT:ChangeStep(ch,c)
	for i=1,c do
		self.brd_data[ch[i][1]][ch[i][2]] = ch[i][3]
	end
end

function ENT:GetTurnPly()
	if self:GetTableTurn() == 1 then
		return self:GetPly1()
	else
		return self:GetPly2()
	end
end
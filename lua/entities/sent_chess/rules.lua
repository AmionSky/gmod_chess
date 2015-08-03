function ENT:CheckKing()
	local ind, x, y, i, j, blocked
	
	if LocalPlayer() == self:GetPly1() then ind = 4
	elseif LocalPlayer() == self:GetPly2() then ind = 20
	else return false end
	
	for i=1,8 do
		for j=1,8 do
			if self.brd_data[i][j] == ind then
				x = i
				y = j
				break
			end
		end
	end
	
	i = x
	j = y
	blocked = false
	while !blocked and i<8 do
		i = i + 1
		if self.brd_data[i][j] != 0 then
			blocked = true
			if ((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
				if self.piece.type[self.brd_data[i][j]] == 1 or self.piece.type[self.brd_data[i][j]] == 5 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x
	j = y
	blocked = false
	while !blocked and i>1 do
		i = i - 1
		if self.brd_data[i][j] != 0 then
			blocked = true
			if ((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
				if self.piece.type[self.brd_data[i][j]] == 1 or self.piece.type[self.brd_data[i][j]] == 5 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x
	j = y
	blocked = false
	while !blocked and j<8 do
		j = j + 1
		if self.brd_data[i][j] != 0 then
			blocked = true
			if ((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
				if self.piece.type[self.brd_data[i][j]] == 1 or self.piece.type[self.brd_data[i][j]] == 5 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x
	j = y
	blocked = false
	while !blocked and j>1 do
		j = j - 1
		if self.brd_data[i][j] != 0 then
			blocked = true
			if ((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
				if self.piece.type[self.brd_data[i][j]] == 1 or self.piece.type[self.brd_data[i][j]] == 5 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end

	i = x+2
	j = y+1
	if i <= 8 and j <= 8 then
		if self.brd_data[i][j] != 0 then
			if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
				if self.piece.type[self.brd_data[i][j]] == 2 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x+2
	j = y-1
	if i <= 8 and j >= 1 then
		if self.brd_data[i][j] != 0 then
			if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
				if self.piece.type[self.brd_data[i][j]] == 2 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x-2
	j = y+1
	if i >= 1 and j <= 8 then
		if self.brd_data[i][j] != 0 then
			if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
				if self.piece.type[self.brd_data[i][j]] == 2 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x-2
	j = y-1
	if i >= 1 and j >= 1 then
		if self.brd_data[i][j] != 0 then
			if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
				if self.piece.type[self.brd_data[i][j]] == 2 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x+1
	j = y+2
	if i <= 8 and j <= 8 then
		if self.brd_data[i][j] != 0 then
			if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
				if self.piece.type[self.brd_data[i][j]] == 2 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x-1
	j = y+2
	if i >= 1 and j <= 8 then
		if self.brd_data[i][j] != 0 then
			if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
				if self.piece.type[self.brd_data[i][j]] == 2 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x+1
	j = y-2
	if i <= 8 and j >= 1 then
		if self.brd_data[i][j] != 0 then
			if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
				if self.piece.type[self.brd_data[i][j]] == 2 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x-1
	j = y-2
	if i >= 1 and j >= 1 then
		if self.brd_data[i][j] != 0 then
			if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
				if self.piece.type[self.brd_data[i][j]] == 2 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end

	i = x
	j = y
	blocked = false
	while !blocked and i < 8 and j > 1 do
		i = i + 1
		j = j - 1
		if self.brd_data[i][j] != 0 then
			blocked = true
			if ((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
				if self.piece.type[self.brd_data[i][j]] == 3 or self.piece.type[self.brd_data[i][j]] == 5 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x
	j = y
	blocked = false
	while !blocked and i < 8 and j < 8 do
		i = i + 1
		j = j + 1
		if self.brd_data[i][j] != 0 then
			blocked = true
			if ((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
				if self.piece.type[self.brd_data[i][j]] == 3 or self.piece.type[self.brd_data[i][j]] == 5 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x
	j = y
	blocked = false
	while !blocked and i > 1 and j < 8 do
		i = i - 1
		j = j + 1
		if self.brd_data[i][j] != 0 then
			blocked = true
			if ((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
				if self.piece.type[self.brd_data[i][j]] == 3 or self.piece.type[self.brd_data[i][j]] == 5 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	i = x
	j = y
	blocked = false
	while !blocked and i > 1 and j > 1 do
		i = i - 1
		j = j - 1				
		if self.brd_data[i][j] != 0 then
			blocked = true
			if ((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
				if self.piece.type[self.brd_data[i][j]] == 3 or self.piece.type[self.brd_data[i][j]] == 5 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	
	if ind <= 16 then
		i = x - 1
		j = y - 1
		if i >= 1 and j >= 1 then
			if self.brd_data[i][j] > 16 then
				if self.piece.type[self.brd_data[i][j]] == 0 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
		i = x + 1
		j = y - 1
		if i <= 8 and j >= 1 then
			if self.brd_data[i][j] > 16 then
				if self.piece.type[self.brd_data[i][j]] == 0 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	else
		i = x + 1
		j = y + 1
		if i <= 8 and j <= 8 then
			if self.brd_data[i][j] <= 16 and self.brd_data[i][j] != 0 then
				if self.piece.type[self.brd_data[i][j]] == 0 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
		i = x - 1
		j = y + 1
		if i >= 1 and j <= 8 then
			if self.brd_data[i][j] <= 16 and self.brd_data[i][j] != 0 then
				if self.piece.type[self.brd_data[i][j]] == 0 then self.kwarn = { ["x"] = x, ["y"] = y } return end
			end
		end
	end
	self.kwarn = { ["x"] = 0, ["y"] = 0 }
	return
end

function ENT:CheckPiece( x, y )
	local ind = self.brd_data[x][y]
	local i, j
	if ( self:GetTableTurn() and ind > 16 ) or ( not self:GetTableTurn() and ind <= 16 ) then return end
	
	self.sel.x = x
	self.sel.y = y
	
	self:ResetAvailable()
	
	local function RookMove()
		local i, j, blocked
		i = x
		j = y
		blocked = false
		while !blocked and i<8 do
			i = i + 1
			if self.brd_data[i][j] != 0 then
				blocked = true
				if !((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
					i = i - 1
				end
			end
			self.available[i][j] = true
		end
		i = x
		j = y
		blocked = false
		while !blocked and i>1 do
			i = i - 1
			if self.brd_data[i][j] != 0 then
				blocked = true
				if !((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
					i = i + 1
				end
			end
			self.available[i][j] = true
		end
		i = x
		j = y
		blocked = false
		while !blocked and j<8 do
			j = j + 1
			if self.brd_data[i][j] != 0 then
				blocked = true
				if !((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
					j = j - 1
				end
			end
			self.available[i][j] = true
		end
		i = x
		j = y
		blocked = false
		while !blocked and j>1 do
			j = j - 1
			if self.brd_data[i][j] != 0 then
				blocked = true
				if !((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
					j = j + 1
				end
			end
			self.available[i][j] = true
		end
	end
	local function KnightMove()
		local i, j
		i = x+2
		j = y+1
		if i <= 8 and j <= 8 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		i = x+2
		j = y-1
		if i <= 8 and j >= 1 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		i = x-2
		j = y+1
		if i >= 1 and j <= 8 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		i = x-2
		j = y-1
		if i >= 1 and j >= 1 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		i = x+1
		j = y+2
		if i <= 8 and j <= 8 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		i = x-1
		j = y+2
		if i >= 1 and j <= 8 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		i = x+1
		j = y-2
		if i <= 8 and j >= 1 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		i = x-1
		j = y-2
		if i >= 1 and j >= 1 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
	end
	local function BishopMove()
		local i, j, blocked
		i = x
		j = y
		blocked = false
		while !blocked and i < 8 and j > 1 do
			i = i + 1
			j = j - 1
			if self.brd_data[i][j] != 0 then
				blocked = true
				if !((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
					i = i - 1
					j = j + 1
				end
			end
			self.available[i][j] = true
		end
		i = x
		j = y
		blocked = false
		while !blocked and i < 8 and j < 8 do
			i = i + 1
			j = j + 1
			if self.brd_data[i][j] != 0 then
				blocked = true
				if !((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
					i = i - 1
					j = j - 1
				end
			end
			self.available[i][j] = true
		end
		i = x
		j = y
		blocked = false
		while !blocked and i > 1 and j < 8 do
			i = i - 1
			j = j + 1
			if self.brd_data[i][j] != 0 then
				blocked = true
				if !((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
					i = i + 1
					j = j - 1
				end
			end
			self.available[i][j] = true
		end
		i = x
		j = y
		blocked = false
		while !blocked and i > 1 and j > 1 do
			i = i - 1
			j = j - 1				
			if self.brd_data[i][j] != 0 then
				blocked = true
				if !((ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16)) then
					i = i + 1
					j = j + 1
				end
			end
			self.available[i][j] = true
		end
	end
	
	if self.piece.type[ind] == 1 then
		RookMove()
	elseif self.piece.type[ind] == 2 then
		KnightMove()
	elseif self.piece.type[ind] == 3 then
		BishopMove()
	elseif self.piece.type[ind] == 4 then
	//
	// King
	//
		//0+
		i = x
		j = y + 1
		if j <= 8 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		//0-
		i = x
		j = y - 1
		if j >= 1 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		//++
		i = x + 1
		j = y + 1
		if i <= 8 and j <= 8 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		//+-
		i = x + 1
		j = y - 1
		if i <= 8 and j >= 1 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		//-+
		i = x - 1
		j = y + 1
		if i >= 1 and j <= 8 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		//--
		i = x - 1
		j = y - 1
		if i >= 1 and j >= 1 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		//+0
		i = x + 1
		j = y
		if i <= 8 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		//-0
		i = x - 1
		j = y
		if i >= 1 then
			if self.brd_data[i][j] == 0 then
				self.available[i][j] = true
			else
				if (ind <= 16 and self.brd_data[i][j] > 16) or (ind > 16 and self.brd_data[i][j] <= 16) then
					self.available[i][j] = true
				end
			end
		end
		// special
		if !self.piece.moved[self.brd_data[x][y]] then
			if x == 4 and y == 8 then
				if self.brd_data[1][8] == 1 then
					if !self.piece.moved[1] then
						if self.brd_data[3][8] == 0 and self.brd_data[2][8] == 0 then
							self.available[2][8] = true
						end
					end
				elseif self.brd_data[8][8] == 8 then
					if !self.piece.moved[8] then
						if self.brd_data[5][8] == 0 and self.brd_data[6][8] == 0 and self.brd_data[7][8] == 0 then
							self.available[6][8] = true
						end
					end
				end
			end
			if x == 4 and y == 1 then
				if self.brd_data[1][1] == 17 then
					if !self.piece.moved[17] then
						if self.brd_data[3][1] == 0 and self.brd_data[2][1] == 0 then
							self.available[2][1] = true
						end
					end
				elseif self.brd_data[8][1] == 24 then
					if !self.piece.moved[24] then
						if self.brd_data[5][1] == 0 and self.brd_data[6][1] == 0 and self.brd_data[7][1] == 0 then
							self.available[6][1] = true
						end
					end
				end
			end
		end
		
	elseif self.piece.type[ind] == 5 then
	//
	//Queen
	//
		RookMove()
		BishopMove()
	else
	//
	// Pawn
	//
		if ind <= 16 then
			//Y-
			i = x
			j = y - 1
			if j >= 1 then
				if self.brd_data[i][j] == 0 then
					self.available[i][j] = true
					if y == 7 then
						if self.brd_data[i][j - 1] == 0 then
							self.available[i][j - 1] = true
						end
					end
				end
			end
			i = x - 1
			j = y - 1
			if i >= 1 and j >= 1 then
				if self.brd_data[i][j] > 16 then
					self.available[i][j] = true
				end
			end
			i = x + 1
			j = y - 1
			if i <= 8 and j >= 1 then
				if self.brd_data[i][j] > 16 then
					self.available[i][j] = true
				end
			end
		else
			//Y+
			i = x
			j = y + 1
			if j <= 8 then
				if self.brd_data[i][j] == 0 then
					self.available[i][j] = true
					if y == 2 then
						if self.brd_data[i][j + 1] == 0 then
							self.available[i][j + 1] = true
						end
					end
				end
			end
			i = x + 1
			j = y + 1
			if i <= 8 and j <= 8 then
				if self.brd_data[i][j] != 0 then
					if self.brd_data[i][j] <= 16 then
						self.available[i][j] = true
					end
				end
			end
			i = x - 1
			j = y + 1
			if i >= 1 and j <= 8 then
				if self.brd_data[i][j] != 0 then
					if self.brd_data[i][j] <= 16 then
						self.available[i][j] = true
					end
				end
			end
		end
	end
	self.available[x][y] = false
end
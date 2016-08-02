local PLAYER = FindMetaTable("Player")

function PLAYER:SetJob(jobname)
	self.Job = job.GetByClass(jobname)
	
	self:SetNWString("PlayerJob", jobname)
end
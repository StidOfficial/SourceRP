local PLAYER = FindMetaTable("Player")

function PLAYER:GetJob()
	return job.GetByClass(self:GetNWString("PlayerJob"))
end

job = {}
local JobInfo = {}

function job.Create(classname, name, color)
	JobClass = {}
	function JobClass:GetClassName()
		return classname
	end
	function JobClass:GetName()
		return name
	end
	function JobClass:GetColor()
		return color
	end
	JobInfo[classname] = JobClass

	return classname
end

function job.GetAll()
	return JobInfo
end

function job.GetByClass(classname)
	return JobInfo[classname]
end
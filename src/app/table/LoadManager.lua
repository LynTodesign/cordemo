local LoadManager = {}
LoadManager.BonesCachedData = nil

function LoadManager.loadSpriteFramesWithFile(png, plist)
	display.addSpriteFrames(plist, png)
end

function LoadManager.getAnimation(param)
	local frames = display.newFrames(param.name, param.sIndex, param.eIndex)
	local anim = display.newAnimation(frames, 2.8 / param.frameRate)
	return cc.Animate:create(anim)
end

function LoadManager.preLoadBonesAnimation(json, atlas)
	LoadManager.BonesCachedData = sp.SkeletonData:create(json, atlas) 
end

function LoadManager.releaseBoneseAnimation()
	LoadManager.BonesCachedData = nil
end

function LoadManager.createBonesAnimation(name, times, isLoop)
	if  not LoadManager.BonesCachedData then
		error("the BonesDate has not preloaded!")
	end
	local spineAnimation = sp.SkeletonAnimation:create(LoadManager.BonesCachedData)
	spineAnimation:setAnimation(times, name, isLoop)
	return spineAnimation	
end

function LoadManager.loadAudio(param)
	
end

return LoadManager
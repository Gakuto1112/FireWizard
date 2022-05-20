--変数
IsWandEquipped = false --杖を装備するかどうか
IsHatWorn = true --帽子を付けているかどうか
VelocityData = {{}, {}} --速度データ：1. 横, 2. 縦
Fps = 60 --FPS、初期値60、20刻み
FpsCountData = {0, 0} --FPSを計測するためのデータ：1. tick, 2. render
IsInMagicAnimation = false
MagicAnimationCount = 0
MagicSoundCount = 0
MagicData = {} --炎の魔法の飛翔体のデータ。 {PlayerPos = [打った瞬間のプレイヤー位置], LookDir = [打った瞬間のプレイヤーの視点の向き], Count = [経過時間], Ttl = [0で爆発アニメーション&消去]}
FlyingPrev = false
FlyAnimationCount = 0

function hidePartTable(parts)
	for index, value in ipairs(parts) do
		value.setEnabled(false)
	end
end

function setFlyingHelmet(path, leather, overlayPath, tag)
	Helmet.setTexture("Resource", path)
	if leather then
		if tag.display ~= nil and tag.display.color ~= nil then
			Helmet.setColor(vectors.intToRGB(tag.display.color))
		else
			Helmet.setColor(vectors.intToRGB(0xA06540))
		end
		HelmetOverlay.setEnabled(true)
	else
		Helmet.setColor(vectors.intToRGB(0xFFFFFF))
		HelmetOverlay.setEnabled(false)
	end
end
function setFlyingChestplate(path, leather, tag)
	for index, part in ipairs(Chestplate) do
		part.setTexture("Resource", path)
		if leather then
			if tag.display ~= nil and tag.display.color ~= nil then
				part.setColor(vectors.intToRGB(tag.display.color))
			else
				part.setColor(vectors.intToRGB(0xA06540))
			end
		else
			part.setColor(vectors.intToRGB(0xFFFFFF))
		end
		part.setEnabled(true)
	end
	if leather then
		for index, part in ipairs(ChestplateOverlay) do
			part.setEnabled(true)
		end
	else
		hidePartTable(ChestplateOverlay)
	end
end

function setFlyingLeggins(path, y, leather, overlayPath, tag)
	for index, part in ipairs(Leggins) do
		if index == 1 then
			part.setTextureSize({64, 32})
			part.setTexture("Resource", path)
		elseif index == 2 or index == 4 then
			part.setUV({96 / 112, (y - 16) / 280})
		else
			part.setUV({96 / 112, (y - 12) / 280})
		end
		if leather then
			if tag.display ~= nil and tag.display.color ~= nil then
				part.setColor(vectors.intToRGB(tag.display.color))
			else
				part.setColor(vectors.intToRGB(0xA06540))
			end
		else
			part.setColor(vectors.intToRGB(0xFFFFFF))
		end
		part.setEnabled(true)
	end
	if leather then
		for index, part in ipairs(LegginsOverlay) do
			if index == 1 then
				part.setTextureSize({64, 32})
				part.setTexture("Resource", overlayPath)
			elseif index == 2 or index == 4 then
				part.setUV({0 / 112, 20 / 280})
			else
				part.setUV({0 / 112, 30 / 280})
			end
			part.setEnabled(true)
		end
	else
		hidePartTable(LegginsOverlay)
	end
end

function setFlyingBoots(y, leather, tag)
	for index, part in ipairs(Boots) do
		if index == 1 or index == 3 then
			part.setUV({96 / 112, (y - 16) / 280})
		else
			part.setUV({96 / 112, (y - 12) / 280})
		end
		if leather then
			if tag.display ~= nil and tag.display.color ~= nil then
				part.setColor(vectors.intToRGB(tag.display.color))
			else
				part.setColor(vectors.intToRGB(0xA06540))
			end
		else
			part.setColor(vectors.intToRGB(0xFFFFFF))
		end
		part.setEnabled(true)
	end
	if leather then
		for index, part in ipairs(BootsOverlay) do
			if index == 1 or index == 3 then
				part.setUV({0 / 112, 10 / 280})
			else
				part.setUV({0 / 112, 20 / 280})
			end
			part.setEnabled(true)
		end
	else
		hidePartTable(BootsOverlay)
	end
end

function setGlint(parts, set)
	if set then
		for index, part in ipairs(parts) do
			part.setShader("Glint")
		end
	else
		for index, part in ipairs(parts) do
			part.setShader("None")
		end
	end
end

function getTableAverage(tagetTable)
	local sum = 0
	for index, value in ipairs(tagetTable) do
		sum = sum + value
	end
	return sum / #tagetTable
end

--デフォルトのプレイヤーモデルを削除
for key, vanillaModel in pairs(vanilla_model) do
	vanillaModel.setEnabled(false)
end

--ネームタグの位置を調整
nameplate.ENTITY.setPos({0, 0.3, 0})

--杖、魔法陣のモデルを非表示
ArmorHelmet = armor_model.HELMET
RightWand = model.RightArm.RightMagicWand
LeftWand = model.LeftArm.LeftMagicWand
Circle1 = model.Body.MagicCircle.MagicCircle1
Circle2 = model.Body.MagicCircle.MagicCircle2
Broom = model.Body.MagicalBroom
BroomLeg = model.Body.BroomLegs
RightBroomArm = model.Body.RightBroomArm
LeftBroomArm = model.Body.LeftBroomArm
Helmet = model.Head.BouguHelmet
HelmetOverlay = model.Head.BouguHelmet.BouguHelmetLeatherOverlay
Chestplate = {model.Body.BouguBody, model.Body.RightBroomArm.RightBroomBouguArm, model.Body.LeftBroomArm.LeftBroomBouguArm, model.RightArm.RightBouguArm, model.LeftArm.LeftBouguArm}
ChestplateOverlay = {model.Body.BouguBody.BouguBodyLeatherOverlay, model.Body.RightBroomArm.RightBroomBouguArm.RightBroomBouguArmLeatherOverlay, model.Body.LeftBroomArm.LeftBroomBouguArm.LeftBroomBouguArmLeatherOverlay, model.RightArm.RightBouguArm.RightBouguArmLeatherOverlay, model.LeftArm.LeftBouguArm.LeftBouguArmLeatherOverlay}
Leggins = {model.Body.BouguLeggins, model.Body.BroomLegs.RightBroomLeg.RightBroomBouguLegTop, model.Body.BroomLegs.RightBroomLeg.RightBroomLegBottom.RightBroomBouguLegBottom, model.Body.BroomLegs.LeftBroomLeg.LeftBroomBouguLegTop, model.Body.BroomLegs.LeftBroomLeg.LeftBroomLegBottom.LeftBroomBouguLegBottom}
LegginsOverlay = {model.Body.BouguLeggins.BouguLegginsLeatherOverlay, model.Body.BroomLegs.RightBroomLeg.RightBroomBouguLegTop.RightBroomBouguLegTopLeatherOverlay, model.Body.BroomLegs.RightBroomLeg.RightBroomLegBottom.RightBroomBouguLegBottom.RightBroomBouguLegBottomLeatherOverlay, model.Body.BroomLegs.LeftBroomLeg.LeftBroomBouguLegTop.LeftBroomBouguLegTopLeatherOverlay, model.Body.BroomLegs.LeftBroomLeg.LeftBroomLegBottom.LeftBroomBouguLegBottom.LeftBroomBouguLegBottomLeatherOverlay}
Boots = {model.Body.BroomLegs.RightBroomLeg.RightBroomBouguBootsTop, model.Body.BroomLegs.RightBroomLeg.RightBroomLegBottom.RightBroomBouguBootsBottom, model.Body.BroomLegs.LeftBroomLeg.LeftBroomBouguBootsTop, model.Body.BroomLegs.LeftBroomLeg.LeftBroomLegBottom.LeftBroomBouguBootsBottom}
BootsOverlay = {model.Body.BroomLegs.RightBroomLeg.RightBroomBouguBootsTop.RightBroomBouguBootsTopLeatherOverlay2, model.Body.BroomLegs.RightBroomLeg.RightBroomLegBottom.RightBroomBouguBootsBottom.RightBroomBouguBootsBottomLeatherOverlay, model.Body.BroomLegs.LeftBroomLeg.LeftBroomBouguBootsTop.LeftBroomBouguBootsTopLeatherOverlay, model.Body.BroomLegs.LeftBroomLeg.LeftBroomLegBottom.LeftBroomBouguBootsBottom.LeftBroomBouguBootsBottomLeatherOverlay}
hidePartTable({ArmorHelmet, RightWand, LeftWand, Circle1, Circle2, Broom, BroomLeg, RightBroomArm, LeftBroomArm, Helmet, HelmetOverlay})
hidePartTable(Chestplate)
hidePartTable(ChestplateOverlay)
hidePartTable(Leggins)
hidePartTable(LegginsOverlay)
hidePartTable(Boots)
hidePartTable(BootsOverlay)
animation["FlyAnimation"].setLoopMode("HOLD")

--オーブのライティングの設定
model.RightArm.RightMagicWand.Orb.setLight({15})
model.LeftArm.LeftMagicWand.Orb2.setLight({15})
Circle1.setLight({15})
Circle2.setLight({15})

--防具のテクスチャサイズ設定
Helmet.setTextureSize({64, 32})
HelmetOverlay.setTextureSize({64, 32})
HelmetOverlay.setTexture("Resource", "minecraft:textures/models/armor/leather_layer_1_overlay.png")
for index, part in ipairs(Chestplate) do
	part.setTextureSize({64, 32})
end
for index, part in ipairs(ChestplateOverlay) do
	part.setTextureSize({64, 32})
	part.setTexture("Resource", "minecraft:textures/models/armor/leather_layer_1_overlay.png")
end

--アクションホイール
--アクション1： 杖の装備/解除
action_wheel.SLOT_1.setTitle("魔法の杖を装備する")
action_wheel.SLOT_1.setItem("minecraft:stick")
action_wheel.SLOT_1.setFunction(function()
	local playerPos = player.getPos()
	local bodyYaw = player.getBodyYaw() % 360 / 180 * math.pi
	local wandPos
	if player.isLeftHanded() then
		wandPos = {{math.cos(bodyYaw - 0.35 * math.pi), math.sin(bodyYaw - 0.35 * math.pi)}, {math.cos(bodyYaw + 0.35 * math.pi), math.sin(bodyYaw + 0.35 * math.pi)}}
	else
		wandPos = {{math.cos(bodyYaw - 0.35 * math.pi + math.pi), math.sin(bodyYaw - 0.35 * math.pi + math.pi)}, {math.cos(bodyYaw + 0.35 * math.pi + math.pi), math.sin(bodyYaw + 0.35 * math.pi + math.pi)}}
	end
	if IsWandEquipped then
		sound.playSound("minecraft:block.lava.extinguish", playerPos, {1, 1})
		for i = 1, 30 do
			particle.addParticle("minecraft:smoke", {playerPos.x + wandPos[1][1] + (wandPos[2][1] - wandPos[1][1]) * (i / 30), playerPos.y + 1, playerPos.z + wandPos[1][2] + (wandPos[2][2] - wandPos[1][2]) * (i / 30), (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2})
		end
		action_wheel.SLOT_1.setTitle("魔法の杖を装備する")
	else
		sound.playSound("minecraft:entity.player.levelup", playerPos, {1, 2})
		for i = 1, 30 do
			particle.addParticle("minecraft:end_rod", {playerPos.x + wandPos[1][1] + (wandPos[2][1] - wandPos[1][1]) * (i / 30), playerPos.y + 1, playerPos.z + wandPos[1][2] + (wandPos[2][2] - wandPos[1][2]) * (i / 30), (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2})
		end
		action_wheel.SLOT_1.setTitle("魔法の杖を外す")
	end
	IsWandEquipped = not IsWandEquipped
end)

--アクション2: 炎の魔法
action_wheel.SLOT_2.setTitle("炎の魔法")
action_wheel.SLOT_2.setItem("minecraft:fire_charge")
action_wheel.SLOT_2.setFunction(function()
	if IsWandEquipped then
		IsInMagicAnimation = true
	else
		print("先に魔法の杖を装備してね！")
	end
end)

--アクション3: 帽子の付け外し
action_wheel.SLOT_3.setTitle("帽子を外す")
action_wheel.SLOT_3.setItem("minecraft:leather_helmet")
action_wheel.SLOT_3.setFunction(function()
	local hat = model.Head.Hat
	local playerPos = player.getPos()
	if IsHatWorn then
		sound.playSound("minecraft:block.lava.extinguish", playerPos, {1, 1})
		hat.setEnabled(false)
		ArmorHelmet.setEnabled(true)
		for i = 1, 30 do
			particle.addParticle("minecraft:smoke", {playerPos.x, playerPos.y + 2, playerPos.z, (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2})
		end
		action_wheel.SLOT_3.setTitle("帽子を被る")
	else
		sound.playSound("minecraft:entity.player.levelup", playerPos, {1, 2})
		hat.setEnabled(true)
		ArmorHelmet.setEnabled(false)
		for i = 1, 30 do
			particle.addParticle("minecraft:end_rod", {playerPos.x, playerPos.y + 2, playerPos.z, (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2})
		end
		action_wheel.SLOT_3.setTitle("帽子を外す")
	end
	IsHatWorn = not IsHatWorn
end)

function tick()
	--杖の処理
	local rightItem = held_item_model.RIGHT_HAND
	local leftItem = held_item_model.LEFT_HAND
	local playerPos = player.getPos()
	if IsWandEquipped then
		if player.isLeftHanded() then
			LeftWand.setEnabled(true)
			RightWand.setEnabled(false)
			leftItem.setEnabled(false)
			rightItem.setEnabled(true)
		else
			RightWand.setEnabled(true)
			LeftWand.setEnabled(false)
			rightItem.setEnabled(false)
			leftItem.setEnabled(true)
		end
	else
		RightWand.setEnabled(false)
		LeftWand.setEnabled(false)
		rightItem.setEnabled(true)
		leftItem.setEnabled(true)
	end

	--杖のパーティクル
	if IsWandEquipped then
		local bodyYaw = player.getBodyYaw() % 360 / 180 * math.pi
		if player.isLeftHanded() then
			particle.addParticle("minecraft:flame", {playerPos.x + math.cos(bodyYaw + 0.35 * math.pi) + (math.random() - 0.5) * 0.5, playerPos.y + 1 + (math.random() - 0.5) * 0.5, playerPos.z + math.sin(bodyYaw + 0.35 * math.pi) + (math.random() - 0.5) * 0.5, 0, 0, 0})
		else
			particle.addParticle("minecraft:flame", {playerPos.x - math.cos(-bodyYaw + 0.35 * math.pi) + (math.random() - 0.5) * 0.5, playerPos.y + 1 + (math.random() - 0.5) * 0.5, playerPos.z + math.sin(-bodyYaw + 0.35 * math.pi) + (math.random() - 0.5) * 0.5, 0, 0, 0})
		end
	end

	--魔法のアニメーション
	if not IsWandEquipped and IsInMagicAnimation then
		Circle1.setEnabled(false)
		Circle2.setEnabled(false)
		animation["FireMagic"].cease()
		IsInMagicAnimation = false
		MagicAnimationCount = 0
	end
	if MagicAnimationCount > 1 then
		Circle1.setEnabled(true)
		Circle2.setEnabled(true)
	else
		Circle1.setEnabled(false)
		Circle2.setEnabled(false)
	end
	if MagicAnimationCount == 1 then
		sound.playSound("minecraft:block.enchantment_table.use", playerPos, {1, 1})
		animation["FireMagic"].start()
	elseif MagicAnimationCount == 15 then
		sound.playSound("minecraft:item.firecharge.use", playerPos, {1, 0.5})
		table.insert(MagicData, {PlayerPos = {playerPos.x, playerPos.y + 1.5, playerPos.z}, LookDir = player.getLookDir(), Count = 0, Ttl = 30})
	end
	if IsInMagicAnimation then
		if MagicSoundCount == 6 then
			sound.playSound("minecraft:item.firecharge.use", playerPos, {0.5, 1})
		end
		for i = 1, 10 do
			particle.addParticle("minecraft:flame", {playerPos.x + (math.random() - 0.5) * 5, playerPos.y + 1 + (math.random() - 0.5) * 5, playerPos.z + (math.random() - 0.5) * 5, 0, 0, 0})
		end
	end

	--クリエイティブ飛行で魔法の箒切り替え
	local rightLeg = model.RightLeg
	local leftLeg = model.LeftLeg
	local bodyYaw = player.getBodyYaw() % 360 / 180 * math.pi
	local broomPos = {{math.cos(bodyYaw - 0.35 * math.pi + math.pi * 0.86), 0, math.sin(bodyYaw - 0.35 * math.pi + math.pi * 0.86)}, {math.cos(bodyYaw - 0.35 * math.pi - math.pi * 0.14) * 1.8, -0.8, math.sin(bodyYaw - 0.35 * math.pi - math.pi * 0.14) * 1.8}}
	local armorParts = {"CHESTPLATE", "LEGGINGS", "BOOTS"}
	if player.isFlying() then
		if not FlyingPrev then
			sound.playSound("minecraft:entity.player.levelup", playerPos, {1, 2})
			for i = 1, 30 do
				particle.addParticle("minecraft:end_rod", {playerPos.x + broomPos[1][1] + (broomPos[2][1] - broomPos[1][1]) * (i / 30), playerPos.y + broomPos[1][2] + (broomPos[2][2] - broomPos[1][2]) * (i / 30) + 1, playerPos.z + broomPos[1][3] + (broomPos[2][3] - broomPos[1][3]) * (i / 30), (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2})
			end
		end
		particle.addParticle("minecraft:end_rod", {playerPos.x + math.cos(bodyYaw - 0.35 * math.pi - math.pi * 0.14) * 1.8, playerPos.y + 0.2, playerPos.z + math.sin(bodyYaw - 0.35 * math.pi - math.pi * 0.14) * 1.8, (math.random() - 0.5) * 0.1, (math.random() - 0.5) * 0.1, (math.random() - 0.5) * 0.1})
		rightLeg.setEnabled(false)
		leftLeg.setEnabled(false)
		Broom.setEnabled(true)
		BroomLeg.setEnabled(true)
		for index, armorPart in ipairs(armorParts) do
			armor_model[armorPart].setEnabled(false)
		end

	else
		if FlyingPrev then
			sound.playSound("minecraft:block.lava.extinguish", playerPos, {1, 1})
			for i = 1, 30 do
				particle.addParticle("minecraft:smoke", {playerPos.x + broomPos[1][1] + (broomPos[2][1] - broomPos[1][1]) * (i / 30), playerPos.y + broomPos[1][2] + (broomPos[2][2] - broomPos[1][2]) * (i / 30) + 1, playerPos.z + broomPos[1][3] + (broomPos[2][3] - broomPos[1][3]) * (i / 30), (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2, (math.random() - 0.5) * 0.2})
			end
		end
		rightLeg.setEnabled(true)
		leftLeg.setEnabled(true)
		Broom.setEnabled(false)
		BroomLeg.setEnabled(false)
		for index, armorPart in ipairs(armorParts) do
			armor_model[armorPart].setEnabled(true)
		end
	end

	--ヘルメットの処理
	local headItem = player.getEquipmentItem(6)
	local hatHelmet = model.Head.Hat.Top1.Top2.Top3.Top5.TopBadge
	if headItem.getType() == "minecraft:leather_helmet" then
		local tag = headItem.getTag()
		hatHelmet.setUV({-64 / 112, 117 / 280})
		if tag.display ~= nil and tag.display.color ~= nil then
			hatHelmet.setColor(vectors.intToRGB(tag.display.color))
		else
			hatHelmet.setColor(vectors.intToRGB(0xA06540))
		end
	elseif headItem.getType() == "minecraft:chainmail_helmet" then
		hatHelmet.setUV({-48 / 112, 117 / 280})
		hatHelmet.setColor(vectors.intToRGB(0xFFFFFF))
	elseif headItem.getType() == "minecraft:iron_helmet" then
		hatHelmet.setUV({-32 / 112, 117 / 280})
		hatHelmet.setColor(vectors.intToRGB(0xFFFFFF))
	elseif headItem.getType() == "minecraft:golden_helmet" then
		hatHelmet.setUV({-16 / 112, 117 / 280})
		hatHelmet.setColor(vectors.intToRGB(0xFFFFFF))
	elseif headItem.getType() == "minecraft:diamond_helmet" then
		hatHelmet.setUV({0 / 112, 117 / 280})
		hatHelmet.setColor(vectors.intToRGB(0xFFFFFF))
	elseif headItem.getType() == "minecraft:netherite_helmet" then
		hatHelmet.setUV({16 / 112, 117 / 280})
		hatHelmet.setColor(vectors.intToRGB(0xFFFFFF))
	elseif headItem.getType() == "minecraft:turtle_helmet" then
		hatHelmet.setUV({-64 / 112, 125 / 280})
		hatHelmet.setColor(vectors.intToRGB(0xFFFFFF))
	else
		hatHelmet.setUV({0 / 112, 0 / 280})
	end
	if headItem.hasGlint() then
		hatHelmet.setShader("Glint")
	else
		hatHelmet.setShader("None")
	end

	--バニラのヘルメットの処理
	local flying = player.isFlying()
	if flying and not IsHatWorn then
		armor_model.HELMET.setEnabled(false)
		Helmet.setEnabled(true)
		if headItem.getType() == "minecraft:leather_helmet" then
			setFlyingHelmet("minecraft:textures/models/armor/leather_layer_1.png", true, "minecraft:textures/models/armor/leather_layer_1_overlay.png", headItem.getTag())
		elseif headItem.getType() == "minecraft:chainmail_helmet" then
			setFlyingHelmet("minecraft:textures/models/armor/chainmail_layer_1.png")
		elseif headItem.getType() == "minecraft:iron_helmet" then
			setFlyingHelmet("minecraft:textures/models/armor/iron_layer_1.png")
		elseif headItem.getType() == "minecraft:golden_helmet" then
			setFlyingHelmet("minecraft:textures/models/armor/gold_layer_1.png")
		elseif headItem.getType() == "minecraft:diamond_helmet" then
			setFlyingHelmet("minecraft:textures/models/armor/diamond_layer_1.png")
		elseif headItem.getType() == "minecraft:netherite_helmet" then
			setFlyingHelmet("minecraft:textures/models/armor/netherite_layer_1.png")
		elseif headItem.getType() == "minecraft:turtle_helmet" then
			setFlyingHelmet("minecraft:textures/models/armor/turtle_layer_1.png")
		else
			Helmet.setEnabled(false)
			HelmetOverlay.setEnabled(false)
		end
		if headItem.hasGlint() then
			Helmet.setShader("Glint")
			HelmetOverlay.setShader("Glint")
		else
			Helmet.setShader("None")
			HelmetOverlay.setShader("None")
		end
		else
		if not IsHatWorn then
			armor_model.HELMET.setEnabled(true)
		end
		Helmet.setEnabled(false)
	end

	--クリエイティブ飛行時の防具の処理
	if flying then
		local chestItem = player.getEquipmentItem(5)
		if chestItem.getType() == "minecraft:leather_chestplate" then
			setFlyingChestplate("minecraft:textures/models/armor/leather_layer_1.png", true, chestItem.getTag())
		elseif chestItem.getType() == "minecraft:chainmail_chestplate" then
			setFlyingChestplate("minecraft:textures/models/armor/chainmail_layer_1.png")
		elseif chestItem.getType() == "minecraft:iron_chestplate" then
			setFlyingChestplate("minecraft:textures/models/armor/iron_layer_1.png")
		elseif chestItem.getType() == "minecraft:golden_chestplate" then
			setFlyingChestplate("minecraft:textures/models/armor/gold_layer_1.png")
		elseif chestItem.getType() == "minecraft:diamond_chestplate" then
			setFlyingChestplate("minecraft:textures/models/armor/diamond_layer_1.png")
		elseif chestItem.getType() == "minecraft:netherite_chestplate" then
			setFlyingChestplate("minecraft:textures/models/armor/netherite_layer_1.png")
		else
			hidePartTable(Chestplate)
			hidePartTable(ChestplateOverlay)
		end
		setGlint(Chestplate, chestItem.hasGlint())
		setGlint(ChestplateOverlay, chestItem.hasGlint())
		local legginsItem = player.getEquipmentItem(4)
		if legginsItem.getType() == "minecraft:leather_leggings" then
			setFlyingLeggins("minecraft:textures/models/armor/leather_layer_2.png", 0, true, "minecraft:textures/models/armor/leather_layer_2_overlay.png", legginsItem.getTag())
		elseif legginsItem.getType() == "minecraft:chainmail_leggings" then
			setFlyingLeggins("minecraft:textures/models/armor/chainmail_layer_2.png", 80)
		elseif legginsItem.getType() == "minecraft:iron_leggings" then
			setFlyingLeggins("minecraft:textures/models/armor/iron_layer_2.png", 120)
		elseif legginsItem.getType() == "minecraft:golden_leggings" then
			setFlyingLeggins("minecraft:textures/models/armor/gold_layer_2.png", 160)
		elseif legginsItem.getType() == "minecraft:diamond_leggings" then
			setFlyingLeggins("minecraft:textures/models/armor/diamond_layer_2.png", 200)
		elseif legginsItem.getType() == "minecraft:netherite_leggings" then
			setFlyingLeggins("minecraft:textures/models/armor/netherite_layer_2.png", 240)
		else
			hidePartTable(Leggins)
			hidePartTable(LegginsOverlay)
		end
		setGlint(Leggins, legginsItem.hasGlint())
		setGlint(LegginsOverlay, legginsItem.hasGlint())
		local bootsItem = player.getEquipmentItem(3)
		if bootsItem.getType() == "minecraft:leather_boots" then
			setFlyingBoots(40, true, bootsItem.getTag())
		elseif bootsItem.getType() == "minecraft:chainmail_boots" then
			setFlyingBoots(100)
		elseif bootsItem.getType() == "minecraft:iron_boots" then
			setFlyingBoots(140)
		elseif bootsItem.getType() == "minecraft:golden_boots" then
			setFlyingBoots(180)
		elseif bootsItem.getType() == "minecraft:diamond_boots" then
			setFlyingBoots(220)
		elseif bootsItem.getType() == "minecraft:netherite_boots" then
			setFlyingBoots(260)
		else
			hidePartTable(Boots)
			hidePartTable(BootsOverlay)
		end
		setGlint(Boots, bootsItem.hasGlint())
		setGlint(BootsOverlay, bootsItem.hasGlint())
	else
		hidePartTable(Chestplate)
		hidePartTable(ChestplateOverlay)
		hidePartTable(Leggins)
		hidePartTable(LegginsOverlay)
		hidePartTable(Boots)
		hidePartTable(BootsOverlay)
	end

	--魔法データ処理
	for index, data in ipairs(MagicData) do
		local targetPosition = {data["PlayerPos"][1] + data["LookDir"]["x"] * data["Count"], data["PlayerPos"][2] +  data["LookDir"]["y"] * data["Count"] * 0.5, data["PlayerPos"][3] +  data["LookDir"]["z"] * data["Count"] * 0.5}
		if data["Ttl"] <= 0 then
			sound.playSound("minecraft:entity.generic.explode", targetPosition, {3, 1})
			for i = 1, 30 do
				particle.addParticle("minecraft:explosion", {targetPosition[1] + (math.random() - 0.5) * 10, targetPosition[2] + (math.random() - 0.5) * 10, targetPosition[3] + (math.random() - 0.5) * 10, 0, 0, 0})
				particle.addParticle("minecraft:flame", {targetPosition[1] + (math.random() - 0.5) * 10, targetPosition[2] + (math.random() - 0.5) * 10, targetPosition[3] + (math.random() - 0.5) * 10, 0, 0, 0})
			end
			table.remove(MagicData, index)
		else
			for i = 1, 10 do
				particle.addParticle("minecraft:flame", {targetPosition[1] + math.random() - 0.5, targetPosition[2] + math.random() - 0.5, targetPosition[3] + math.random() - 0.5, 0, 0, 0})
			end
			data["Count"] = data["Count"] + 1
			data["Ttl"] = data["Ttl"] - 1
		end
	end

	--チック終了処理
	FpsCountData[1] = FpsCountData[1] + 1
	if IsInMagicAnimation then
		if MagicAnimationCount > 60 then
			IsInMagicAnimation = false
			MagicAnimationCount = 0
		else
			MagicAnimationCount = MagicAnimationCount + 1
		end
		if MagicSoundCount > 6 then
			MagicSoundCount = 0
		else
			MagicSoundCount = MagicSoundCount + 1
		end
	else
		MagicAnimationCount = 0
		MagicSoundCount = 0
	end
	if flying then
		if FlyAnimationCount >= 60 then
			FlyAnimationCount = 0
		else
			FlyAnimationCount = FlyAnimationCount + 1
		end
	else
		FlyAnimationCount = 0
	end
	FlyingPrev = flying
end

function render(delta)
	--FPS計測
	if FpsCountData[1] >= 1 then
		Fps = FpsCountData[2] * 20
		FpsCountData = {0, 0}
	end

	--髪のアニメーション
	--チェストプレート着用の場合は髪をずらす。
	local frontHair = model.Body.Hairs.FrontHair
	local backHair = model.Body.Hairs.BackHair
	if string.find(player.getEquipmentItem(5).getType(), "chestplate$") and not HideArmor then
		frontHair.setPos({0, 0, -1.1})
		backHair.setPos({0, 0, 1.1})
	else
		frontHair.setPos({0, 0, 0})
		backHair.setPos({0, 0, 0})
	end

	--直近1秒間の横方向、縦方向の移動速度の平均を求める（横方向の場合、前に動いているか、後ろに動いているかも考慮する）。
	local velocity = player.getVelocity()
	local playerSpeed = math.sqrt(math.abs(velocity.x ^ 2 + velocity.z ^ 2))
	local velocityRot = math.deg(math.atan2(velocity.z, velocity.x))
	if velocityRot < 0 then
		velocityRot = 360 + velocityRot
	end
	local bodyYaw = (player.getBodyYaw() - 270) % 360
	local playerAnimation = player.getAnimation()
	if velocityRot == velocityRot then
		local directionAbs = math.abs(velocityRot - bodyYaw)
		if math.min(directionAbs, 360 - directionAbs) < 90 then
			table.insert(VelocityData[1], playerSpeed)
		else
			table.insert(VelocityData[1], -playerSpeed)
		end
	else
		table.insert(VelocityData[1], 0)
	end
	table.insert(VelocityData[2], velocity.y)
	for index, velocityTable in ipairs(VelocityData) do
		while #velocityTable > Fps * 0.25 do
			table.remove(velocityTable, 1)
		end
	end
	--求めた平均から髪の角度を決定する。
	local hairLimit
	if player.getEquipmentItem(5).getType() == "minecraft:elytra" then
		hairLimit = {{0, 80}, {0, 0}}
	elseif string.find(player.getEquipmentItem(5).getType(), "chestplate$") then
		hairLimit = {{0, 80}, {-80, 0}}
	else
		hairLimit = {{0, 80}, {-80, 0}}
	end
	local horizontalAverage = getTableAverage(VelocityData[1])
	local verticalAverage = getTableAverage(VelocityData[2])
	local sneakOffset = 0
	if player.isSneaking() then
		sneakOffset = 30
	end
	local frontHair = model.Body.Hairs.FrontHair
	local backHair = model.Body.Hairs.BackHair
	if playerAnimation == "FALL_FLYING" then
		frontHair.setRot({math.min(math.max(hairLimit[1][2] - math.sqrt(horizontalAverage ^ 2 + verticalAverage ^ 2) * 80, hairLimit[1][1]), hairLimit[1][2]), 0, 0})
		backHair.setRot({0, 0, 0})
	elseif playerAnimation == "SWIMMING" then
		frontHair.setRot({math.min(math.max(hairLimit[1][2] - math.sqrt(horizontalAverage ^ 2 + verticalAverage ^ 2) * 320, hairLimit[1][1]), hairLimit[1][2]), 0, 0})
		backHair.setRot({0, 0, 0})
	else
		if verticalAverage < 0 then
			frontHair.setRot({math.min(math.max(-horizontalAverage * 160 - verticalAverage * 80 + sneakOffset, hairLimit[1][1]), hairLimit[1][2]), 0, 0})
			backHair.setRot({math.min(math.max(-horizontalAverage * 160 + verticalAverage * 80 + sneakOffset, hairLimit[2][1]), hairLimit[2][2]), 0, 0})
		else
			frontHair.setRot({math.min(math.max(-horizontalAverage * 160 + sneakOffset, hairLimit[1][1]), hairLimit[1][2]), 0, 0})
			backHair.setRot({math.min(math.max(-horizontalAverage * 160 + sneakOffset, hairLimit[2][1]), hairLimit[2][2]), 0, 0})
		end
	end
	
	--一人称視点の時の杖の表示
	local rightArm = vanilla_model.RIGHT_ARM
	local rightArmLayer = vanilla_model.RIGHT_SLEEVE
	local leftArm = vanilla_model.LEFT_ARM
	local leftArmLayer = vanilla_model.LEFT_SLEEVE
	if renderer.isFirstPerson() then
		if IsWandEquipped then
			rightArm.setRot({0, 1.1, -0.4})
			rightArmLayer.setRot({0, 1.1, -0.4})
			leftArm.setRot({0, -1.1, 0.4})
			leftArmLayer.setRot({0, -1.1, 0.4})
		else
			rightArm.setRot({0, 0, 0})
			rightArmLayer.setRot({0, 0, 0})
			leftArm.setRot({0, 0, 0})
			leftArmLayer.setRot({0, 0, 0})
		end
	else
		rightArm.setRot({0, 0, 0})
		rightArmLayer.setRot({0, 0, 0})
		leftArm.setRot({0, 0, 0})
		leftArmLayer.setRot({0, 0, 0})
	end

	--クリエイティブ飛行時の腕の処理
	local rightArmModel = model.RightArm
	local leftArmModel = model.LeftArm
	if not renderer.isFirstPerson() then
		local leftHanded = player.isLeftHanded()
		local flying = player.isFlying()
		local heldItem = {player.getHeldItem(1), player.getHeldItem(2)}
		if flying then
			animation["FlyAnimation"].start()
			if (leftHanded and heldItem[2] ~= nil) or (not leftHanded and heldItem[1] ~= nil) or (not leftHanded and IsWandEquipped) then
				rightArmModel.setEnabled(true)
				RightBroomArm.setEnabled(false)
			else
				rightArmModel.setEnabled(false)
				RightBroomArm.setEnabled(true)
			end
			if (leftHanded and heldItem[1] ~= nil) or (not leftHanded and heldItem[2] ~= nil) or (leftHanded and IsWandEquipped) then
				leftArmModel.setEnabled(true)
				LeftBroomArm.setEnabled(false)
			else
				leftArmModel.setEnabled(false)
				LeftBroomArm.setEnabled(true)
			end
		else
			animation["FlyAnimation"].stop()
			rightArmModel.setEnabled(true)
			leftArmModel.setEnabled(true)
			RightBroomArm.setEnabled(false)
			LeftBroomArm.setEnabled(false)
		end
	else
		rightArmModel.setEnabled(true)
		RightBroomArm.setEnabled(false)
		leftArmModel.setEnabled(true)
		LeftBroomArm.setEnabled(false)
end

	--レンダー終了処理
	FpsCountData[2] = FpsCountData[2] + 1
end
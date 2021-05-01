local TerrainUtil = require(script.Parent.TerrainUtil)
local TerrainEnum = require(script.Parent.TerrainEnum)

return function ()
  describe('isConvertibleToTerrain', function()
    local ictt = TerrainUtil.isConvertibleToTerrain

    it('should not allow nil', function()
      expect(ictt(nil)).to.equal(false)
    end)

    it('should not allow terrain', function()
      expect(ictt(workspace.Terrain)).to.equal(false)
    end)

    it('should not allow non-basepart objects', function()
      local frame = Instance.new('ScreenGui')

      expect(ictt(frame)).to.equal(false)
    end)

    it('should not allow npc body parts', function()
      local npcModel = Instance.new('Model')

      local HumanoidRootPart = Instance.new('Part')
      HumanoidRootPart.Name = 'HumanoidRootPart'
      HumanoidRootPart.Parent = npcModel

      local Humanoid = Instance.new('Humanoid')
      Humanoid.Parent = npcModel

      expect(ictt(HumanoidRootPart)).to.equal(false)
    end)

    it('should not allow mesh and union parts', function()
      local parent = Instance.new('Model')

      local meshPart = Instance.new('MeshPart')
      meshPart.Parent = parent
      local union = Instance.new('UnionOperation')
      union.Parent = parent
      local negate = Instance.new('NegateOperation')
      negate.Parent = parent

      expect(ictt(meshPart)).to.equal(false)
      expect(ictt(union)).to.equal(false)
      expect(ictt(negate)).to.equal(false)
    end)

    it('should allow parts that meet the rules', function()
      local parent = Instance.new('Model')
      local part = Instance.new('Part')
      part.Size = Vector3.new(4, 4, 4)
      part.Parent = parent
      expect(ictt(part)).to.equal(true)
    end)
  end)

  describe('getPartShape', function()
    local gps = TerrainUtil.getPartShape
    local ShapeEnum = TerrainEnum.Shape

    it('should support part.Shape', function()
      local p = Instance.new('Part')

      p.Shape = Enum.PartType.Ball
      local shape = gps(p)
      expect(shape).to.equal(ShapeEnum.Ball)

      p.Shape = Enum.PartType.Cylinder
      shape = gps(p)
      expect(shape).to.equal(ShapeEnum.CylinderRotate)

      p.Shape = Enum.PartType.Block
      shape = gps(p)
      expect(shape).to.equal(ShapeEnum.Block)
    end)

    it('should support Meshes', function()
      local p = Instance.new('Part')
      local mesh = Instance.new('SpecialMesh')
      mesh.Parent = p

      mesh.MeshType = Enum.MeshType.Cylinder
      local shape = gps(p)
      expect(shape).to.equal(ShapeEnum.CylinderRotate)

      mesh.MeshType = Enum.MeshType.Head
      shape = gps(p)
      expect(shape).to.equal(ShapeEnum.Cylinder)

      mesh.MeshType = Enum.MeshType.Sphere
      shape = gps(p)
      expect(shape).to.equal(ShapeEnum.Ball)

      mesh.MeshType = Enum.MeshType.Wedge
      shape = gps(p)
      expect(shape).to.equal(ShapeEnum.Wedge)

      -- Should use the fallback shape of Block
      mesh.MeshType = Enum.MeshType.Torso
      shape = gps(p)
      expect(shape).to.equal(ShapeEnum.Block)
    end)

    it('should support WedgeParts', function()
      local wedge = Instance.new('WedgePart')

      local shape = gps(wedge)
      expect(shape).to.equal(ShapeEnum.Wedge)
    end)

    it('should support unknown part types', function()
      local truss = Instance.new('TrussPart')
      local shape = gps(truss)
      expect(shape).to.equal(ShapeEnum.Block)

      local CornerWedge = Instance.new('CornerWedgePart')
      shape = gps(CornerWedge)
      expect(shape).to.equal(ShapeEnum.Block)
    end)
  end)

  describe('convertToTerrain', function()
    local CTT = TerrainUtil.convertToTerrain

    beforeEach(function()
      workspace.Terrain:Clear()
    end)

    it('should turn Ball into terrain', function()
      local cframe = CFrame.new()
      local size = Vector3.new(8, 8, 8)

      local success, errorCode = CTT(TerrainEnum.Shape.Ball, Enum.Material.Grass, cframe, size)

      expect(success).to.equal(true)
      expect(errorCode).to.equal(nil)
    end)

    it('should turn Block into terrain', function()
      local cframe = CFrame.new()
      local size = Vector3.new(8, 8, 8)

      local success, errorCode = CTT(TerrainEnum.Shape.Block, Enum.Material.Grass, cframe, size)

      expect(success).to.equal(true)
      expect(errorCode).to.equal(nil)
    end)

    it('should turn Cylinder into terrain', function()
      local cframe = CFrame.new()
      local size = Vector3.new(16, 8, 8)

      local success, errorCode = CTT(TerrainEnum.Shape.Cylinder, Enum.Material.Grass, cframe, size)

      expect(success).to.equal(true)
      expect(errorCode).to.equal(nil)
    end)

    it('should turn CylinderRotate into terrain', function()
      local cframe = CFrame.new()
      local size = Vector3.new(16, 8, 8)

      local success, errorCode = CTT(TerrainEnum.Shape.CylinderRotate, Enum.Material.Grass, cframe, size)

      expect(success).to.equal(true)
      expect(errorCode).to.equal(nil)
    end)

    it('should return false on unsupported parts', function()
      local success, errorCode = CTT('FakePartType')

      expect(success).to.equal(false)
      expect(errorCode).to.equal(TerrainEnum.ConvertError.UnknownShape)
    end)

  end)

end

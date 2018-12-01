require "./spec_helper"
include Carat


describe Carat do
  describe Tensor do
    it "create zeros" do
      tensor = Tensor.new(2, 2)
      t = (0...4).all? do |i|
        tensor.@data[i] == 0
      end
      t.should be_true
      tensor.@dims.should eq({2, 2})
    end

    it "create with block" do
      tensor = Tensor.new(2, 2) do |i, j|
        (i + j * 2).to_f
      end
      puts tensor.to_s
      t = (0...4).all? do |i|
        tensor.@data[i] == i.to_f
      end
      tensor.@dims.should eq({2, 2})
      t.should eq(true)
    end

    it "create from array" do
      tensor = Tensor[2, 2].new([[0.0, 1.0], [2.0, 3.0]])
      t = (0...4).all? do |i|
        tensor[i] == i.to_f
      end
    end

    it "equal other array" do
      tensor1 = Tensor[2, 2].new([[0.0, 1.0], [2.0, 3.0]])
      tensor2 = Tensor[2, 2].new([[0.0, 1.0], [2.0, 3.0]])
      tensor1.should eq(tensor2)
    end

    it "equal itself" do
      tensor = Tensor[2, 2].new([[0.0, 1.0], [2.0, 3.0]])
      tensor.should eq(tensor)
    end

    it "one dimensional tensor equal to scalar" do
      tensor = Tensor[1, 1].new([[42.0]])
      tensor.should eq(42.0)
    end

    tensor = Tensor.new(3, 3) do |i, j|
      (i * 3 + j).to_f
    end

    it "serializes" do
      tensor.to_s.should eq("[[ 0 1 2 ]\n [ 3 4 5 ]\n [ 6 7 8 ]]")
    end

    it "index with int" do
      tensor[1, 1].should eq((1 * 3 + 1).to_f)
    end

    it "slice with range" do
      tensor[0...2, 0...2].should eq(Tensor[2, 2].new([[0, 1], [3, 4]]))
    end

    it "mixed indexing" do
      tensor[0, 0...2].should eq(Tensor[2].new([0, 1]))
    end

    it "add to constant" do
      (tensor + 2.0).should eq(Tensor[3, 3].new([[2.0, 3.0, 4.0],
                                                 [5.0, 6.0, 7.0],
                                                 [8.0, 9.0, 10.0]]))
    end

    it "add constant to" do
      (2.0 + tensor).should eq(Tensor[3, 3].new([[2.0, 3.0, 4.0],
                                                 [5.0, 6.0, 7.0],
                                                 [8.0, 9.0, 10.0]]))
    end

    it "add two tensors" do
      (tensor + tensor).should eq(Tensor[3, 3].new([[0.0, 2.0, 4.0],
                                                    [6.0, 8.0, 10.0],
                                                    [12.0, 14.0, 16.0]]))
    end
  end
end

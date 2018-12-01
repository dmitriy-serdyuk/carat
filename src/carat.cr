# TODO: Write documentation for `Carat`
module Carat
  VERSION = "0.0.1"

  struct Vector(T)
    def initialize()
    end
  end

  struct Matrix(T)
    def initialize()
    end
  end

  struct TensorView(T)
  end

  class DimensionMismatch < Exception
    def initialize(msg = "Dimension mismatch")
    end
  end

  struct Tensor(T, DimTuple)
    protected def initialize(@dims : DimTuple, @strides : DimTuple,
                             @data : Pointer(T), @data_size : Int32)
    end

    protected def self.ind_to_dim(i, dims : Tuple)
      index_in_block = i
      indeces = (dims.map { |dim| 0 }).to_a
      dims.each_with_index do |dim, i|
        indeces[i] = index_in_block % dim
        index_in_block = index_in_block / dim
      end
      typeof(dims).from(indeces)
    end

    def self.new(*dims : Int32)
      strides = (dims.map { |v| 1 }).to_a
      size = dims.reduce(1) { |acc, v| acc * v }
      data = Pointer(Float64).malloc(size)
      Tensor.new(dims, typeof(dims).from(strides), data, size)
    end

    def self.new(*dims : Int32, &block)
      strides = (dims.map { |v| 1 }).to_a
      size = dims.reduce(1) { |acc, v| acc * v }
      data = Pointer.malloc(size) do |i|
        yield *self.ind_to_dim(i, dims)
      end
      Tensor.new(dims, typeof(dims).from(strides), data, size)
    end

    def self.new(dims : DimTuple, array : Array)
      a = array
      i = 0
      while a.is_a? Array
        raise DimensionMismatch.new unless a.size == dims[i]
        a = a[0]
        i += 1
      end
      flat_array = array.flatten
      Tensor.new(dims, dims.map { |v| 1 },
                 flat_array.to_unsafe, flat_array.size) end

    private class TensorHelper(T)
      def initialize(@dims : T)
      end

      def new(array : Array)
        a = array
        while a.is_a? Array
          a = a[0]
        end
        Tensor(typeof(a), T).new(@dims, array)
      end
    end

    def self.[](*dims)
      TensorHelper(typeof(dims)).new(dims)
    end

    def [](*indeces : Int | Range | Tuple(Range, Int32))
      raise DimensionMismatch.new if indeces.size > @dims.size
      if @dims.size == 1
        case indeces
        when Int
        when Range
        when Tuple
        end
      else
        first_index = indeces[0]
        rest_indeces = indeces.skip(1)
        case indeces
        when Int

        when Range

        when Tuple

        end
      end
    end

    def +(other : Tensor(T, DimTuple))
      raise DimensionMismatch.new unless @dims.zip(other.@dims).all? { |(v1, v2)| v1 == v2 }
      # TODO implementation
    end

    def self.add(first : Tensor(T, DimTuple), second : T)
      self.add(second, first)
    end

    def self.add(first : T, second : Tensor(T, DimTuple))
      # TODO fast implementation
      second.@data.map!(second.@data_size) do |v|
        v + first
      end
    end

    def +(other : T)
      self.class.add(self, other)
    end

    def to_s(io : IO)
      io << Array(T).new(@data_size) { |i| @data[i]}
    end
  end
end

struct Number
  def +(other : Tensor)
    typeof(other).add(self, other)
  end

  def *(other : Tensor)
    other * self
  end

  def /(other : Tensor)
    other.divide(self)
  end

  def -(other : Tensor)
    other.subtract(self)
  end
end

# carat

A library for numerical and scientific computation. (Work in progress)

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  carat:
    github: your-github-user/carat
```
2. Run `shards install`

## Usage

```crystal
require "carat"
```

### Tensors

Carat defines class `Tensor` which is (numpy-style) n-dimensional tensor.

#### Create tensor

It can be created in a number of ways:
- Tensor containing zeros
  ```crystal
  Tensor.new(2, 2)
  # [[ 0.0 0.0 ]
  #  [ 0.0 0.0 ]]
  ```
- With block
  ```crystal
  Tensor.new(2, 2) do |i, j|
    (i + j).to_f
  end
  # [[ 0.0 1.0 ]
  #  [ 1.0 2.0 ]]
  ```
- From a regular `Array`
  ```crystal
  Tensor[2, 2].new([[0.0, 1.0], [1.0, 2.0]])
  # [[ 0.0 1.0 ]
  #  [ 1.0 2.0 ]]
  ```
  
#### Index tensor

- By integer
  ```crystal
  tensor = Tensor.new(3, 3) { |i, j| i + j }
  tensor[1, 1]
  # 2.0
  ```
  Or
  ```crystal
  tensor[1]
  # [ 1.0 2.0 3.0 ]
  ```
- By range
  ```crystal
  tensor[0...2, 0...2]
  # [[ 0.0 1.0 ]
  #  [ 1.0 2.0 ]] 
  ```
- By range with step
  ```crystal
  tensor[0..2..4, 0..2..4]
  # [[ 0.0 2.0 ]
  #  [ 2.0 4.0 ]] 
  ```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/carat/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Dmitriy Serdyuk](https://github.com/your-github-user) - creator and maintainer

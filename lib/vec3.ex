defmodule Vec3 do

  @type vec3 :: {float, float, float}

  @doc """
  Builds a new vector.
  """
  @spec new(number, number, number) :: vec3
  def new(x, y, z) when is_integer(x) and is_integer(x) and is_integer(z) do
    {x * 1.0, y * 1.0, z * 1.0} # convert to float
  end

  def new(x, y, z) when is_float(x) and is_float(x) and is_float(z) do
    {x, y, z}
  end

  @doc """
  Builds the zero vector.
  """
  @spec zero() :: vec3
  def zero() do
    {0.0, 0.0, 0.0}
  end

  @doc """
  Adds `vector1` to `vector2`.
  
  `vector1 + vector2`
  """
  @spec add(vec3, vec3) :: vec3
  def add({_x1, _y1, _z1} = vector1, {_x2, _y2, _z2} = vector2) do
    zip(vector1, vector2, &+/2)
  end

  @doc """
  Subtracts `vector2` from `vector1`.
  
  `vector1 - vector2`
  """
  @spec sub(vec3, vec3) :: vec3
  def sub({_x1, _y1, _z1} = vector1, {_x2, _y2, _z2} = vector2) do
    zip(vector1, vector2, &-/2)
  end

  @doc """
  Multiplies `vector1` by a scalar.
  
  `scalar * vector1`
  """
  @spec scale(vec3, float) :: vec3
  def scale({_x1, _y1, _z1} = vector1, scalar) do
    map(vector1, &(&1 * scalar))
  end

  @doc """
  Normalizes `vector`. (Produces the unit vector in the direction of `vector`)
  
  Normalizing the zero vector ({0, 0, 0}) is an undefined behavior. By default
  the result of undefined is the zero vector, otherwise the term passed through
  the additional `undefined` parameter is returned.
  """
  @spec normalize(vec3) :: vec3
  def normalize({_x, _y, _z} = vector) do
    normalize(vector, {0, 0, 0})
  end

  @spec normalize(vec3, any) :: any
  def normalize({_x, _y, _z} = vector, undefined) do
    vector_length = Vec3.length(vector)
    if vector_length != 0,
      do: map(vector, &(&1 / vector_length)),
    else: undefined
  end

  @doc """
  Takes the cross product (also known as "vector product") of `vector1` and
  `vector2`.
  
  `vector1 X vector2`
  """
  @spec cross(vec3, vec3) :: vec3
  def cross({x1, y1, z1} = _vector1, {x2, y2, z2} = _vector2) do
    {
      y1 * z2 - z1 * y2,
      z1 * x2 - x1 * z2,
      x1 * y2 - y1 * x2
    }
  end

  @doc """
  Takes the dot product (also known as "inner product", or "scalar product") of
  `vector1` and `vector2`.
  
  `vector1 · vector2`
  """
  @spec dot(vec3, vec3) :: float
  def dot({_x1, _y1, _z1} = vector1, {_x2, _y2, _z2} = vector2) do
    {i, j, k} = zip vector1, vector2, &(&1 * &2)
    i + j + k
  end

  @doc """
  Calculates the length (also known as "magnitude", or "norm") of a vector.
  """
  @spec length(vec3) :: float
  def length({_x, _y, _z} = vector) do
    :math.sqrt(length_sqr vector)
  end

  @doc """
  Calculates the length (also known as "magnitude", or "norm") squared of a
  vector. This is more accurate and faster to use when comparing vectors than
  `length`.
  """
  @spec length_sqr(vec3) :: float
  def length_sqr({_x, _y, _z} = vector) do
    {i, j, k} = map vector, &(&1 * &1)
    i + j + k
  end

  @doc """
  Calculates the distance between two points represented as vectors.
  
  `|| point1 - point2 ||`
  """
  @spec distance(vec3, vec3) :: float
  def distance({_x1, _y1, _z1} = point1, {_x2, _y2, _z2} = point2) do
    sub(point1, point2) |> Vec3.length
  end

  @doc """
  Calculates the angle in radians between two vectors.
  
  The angle between the zero vector and any vector is undefined. By default, 90
  degrees is returned (as radians), otherwise the term passed as `undefined` is
  returned.
  """
  @spec angle(vec3, vec3) :: float
  def angle({_x1, _y1, _z1} = vector1, {_x2, _y2, _z2} = vector2) do
    angle(vector1, vector2, 90 * (:math.pi / 180))
  end

  @spec angle(vec3, vec3, any) :: float
  def angle({0, 0, 0} = _vector1, _, undefined) do
    undefined
  end

  def angle(_, {0, 0, 0} = _vector2, undefined) do
    undefined
  end

  def angle({_x1, _y1, _z1} = vector1, {_x2, _y2, _z2} = vector2, _undefined) do
    :math.acos(dot(vector1, vector2) / (Vec3.length(vector1) * Vec3.length(vector2)))
  end

  @doc """
  Calculates a linear interpolation between two vectors, where `t` is the
  interpolant and its value is between 0 and 1.
  
  The resulting vector components are always between the components of the
  vectors passed as parameters, even for values of `t` outside the range of 0
  and 1.
  """
  @spec lerp(vec3, vec3, float) :: vec3
  def lerp({_x1, _y1, _z1} = vector1, {_x2, _y2, _z2} = vector2, t) do
    lerp_component =
      fn(n1, n2) ->
        {lower, upper} = Enum.min_max([n1, n2])
        interpolated_value = (_distance = upper - lower) * t + lower
        _clamped =
          [lower,
           interpolated_value,
           upper] |> Enum.sort |> Enum.at(1)
      end
    zip(vector1, vector2, lerp_component)
  end

  @doc """
  Interpolates a quadratic bezier curve ("C" curve). (Implements the
  De Casteljau's algorithm.)
  """
  @spec bezier(vec3, vec3, vec3, float) :: vec3
  def bezier(start_position, mid_tangent, end_position, t) do
    a = lerp(start_position, mid_tangent, t)
    b = lerp(mid_tangent, end_position, t)
    lerp(a, b, t)
  end

  @doc """
  Interpolates a cubic bezier curve ("S" curve). (Implements the
  De Casteljau's algorithm.)
  """
  @spec bezier(vec3, vec3, vec3, vec3, float) :: vec3
  def bezier(start_position, start_tangent, end_position, end_tangent, t) do
    a = lerp(start_position, start_tangent, t)
    b = lerp(start_tangent, end_position, t)
    c = lerp(end_position, end_tangent, t)
    m = lerp(a, b, t)
    n = lerp(b, c, t)
    lerp(m, n, t)
  end

  @doc """
  Rearranges the components of a vector. Why, you ask? Because I saw it in a
  book on shaders, and pattern matching is neat, so I wrote it.
  """
  @spec swizzle(vec3, :xyz | :xzy | :yxz | :yzx | :zxy | :zyx) :: vec3
  def swizzle({x, y, z}, :xyz) do
    {x, y, z}
  end

  def swizzle({x, y, z}, :xzy) do
    {x, z, y}
  end

  def swizzle({x, y, z}, :yxz) do
    {y, x, z}
  end

  def swizzle({x, y, z}, :yzx) do
    {y, z, x}
  end

  def swizzle({x, y, z}, :zxy) do
    {z, x, y}
  end

  def swizzle({x, y, z}, :zyx) do
    {z, y, x}
  end

  @doc """
  Applies `mapper` component-wise on a vector, where mapper is an arity of 1
  function that is passed the component as its parameter.
  """
  @spec map(vec3, fun) :: {any, any, any}
  def map({x, y, z}, mapper) do
    {mapper.(x), mapper.(y), mapper.(z)}
  end

  @doc """
  Applies `zipper` component-wise on 2 vectors, where zipper is an arity of 2
  function that is passed the components of each vector as its parameters.
  """
  @spec zip(vec3, vec3, fun) :: {any, any, any}
  def zip({x1, y1, z1}, {x2, y2, z2}, zipper) do
    {zipper.(x1, x2), zipper.(y1, y2), zipper.(z1, z2)}
  end
end

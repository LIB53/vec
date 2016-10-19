defmodule Vec3Test do
  use ExUnit.Case
  doctest Vec3


  test "new" do
    assert Vec3.new(7, 7, 7) == {7, 7, 7}
    assert Vec3.new(1, 2, 3) == {1, 2, 3}
  end

  test "zero" do
    assert Vec3.new(0, 0, 0) == {0, 0, 0}
  end

  test "add" do
    assert Vec3.add({1, 2, 3}, {6, 5 ,4}) == {7, 7, 7}
  end

  test "sub" do
    assert Vec3.sub({1, 2, 3}, {6, 5, 4}) == {-5, -3, -1}
  end

  test "scale" do
    assert Vec3.scale({1, 1, 1}, 4) == {4, 4, 4}
  end

  test "normalize" do
    assert Vec3.normalize({0, 0, 0}, :undefined) == :undefined
    assert Vec3.normalize({0, 0, 0}) == {0, 0, 0}
    assert Vec3.normalize({1, 0, 0}) == {1, 0, 0}
  end

  test "cross" do
    assert Vec3.cross({0, 0, 0}, {0, 0, 0}) == {0, 0, 0}
  end

  test "dot" do
    assert Vec3.dot({1, 2, 3}, {1, 1, 1}) == 6
    assert Vec3.dot({1, 2, 3}, {0 ,0, 0}) == 0
    assert Vec3.dot({1, 2, 3}, {-2, 0 ,5}) == 13
  end

  test "length_sqr" do
    assert Vec3.length_sqr({-1, -1, -1}) == 3
    assert Vec3.length_sqr({0, 0, 0}) == 0
    assert Vec3.length_sqr({1, 1, 1}) == 3
  end

  test "angle" do
    assert Vec3.angle({0, 0, 0}, {0, 0, 0}, :undefined) == :undefined
    assert (Vec3.angle({0, 0, 0}, {0, 0, 0}) |> Float.round(6)) == 1.570796
    assert (Vec3.angle({1, 0, 0}, {0, 2, 0}, :undefined) |> Float.round(6)) == 1.570796
  end

  test "distance" do
    assert (Vec3.distance({0, 0, 0}, {1, 1, 1}) |> Float.round(6)) == 1.732051
    assert (Vec3.distance({-7, -4, 3}, {17, 6, 2.5}) |> Float.round(6)) == 26.004807
  end

  test "lerp" do
    assert Vec3.lerp({0, 0, 0}, {1, 1, 1}, 0.5) == {0.5, 0.5, 0.5}
    assert Vec3.lerp({1, 1, 1}, {0, 0, 0}, 0.99) == {0.99, 0.99, 0.99}
    assert Vec3.lerp({-1, -1, -1}, {1, 1, 1}, 0.5) == {0, 0, 0}
  end

  test "quadratic bezier" do
    assert Vec3.bezier({0, 0, 0}, {0, 0, 0}, {0, 0, 0}, 0.5) == {0, 0, 0}
    assert Vec3.bezier({1, 1, 1}, {1, 1, 1}, {1, 1, 1}, 1.5) == {1, 1, 1}
    assert Vec3.bezier({0, 0, 0}, {0.5, 0.5, 0.5}, {1, 1, 1}, 0.5) == {0.5, 0.5, 0.5}
  end

  test "cubic bezier" do
    assert Vec3.bezier({0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, 0.5) == {0, 0, 0}
    assert Vec3.bezier({1, 1, 1}, {1, 1, 1}, {1, 1, 1}, {1, 1, 1}, 1.5) == {1, 1, 1}
  end

  test "length" do
    assert ({0, 0, 0} |> Vec3.length |> Float.round(1)) == 0.0
    assert ({1, 1, 1} |> Vec3.length |> Float.round(6)) == 1.732051
    assert ({-1, -1, -1} |> Vec3.length |> Float.round(6)) == 1.732051
  end

  test "swizzle" do
    assert Vec3.swizzle({1, 2, 3}, :xyz) == {1, 2, 3}
    assert Vec3.swizzle({1, 2, 3}, :xzy) == {1, 3, 2}
    assert Vec3.swizzle({1, 2, 3}, :yxz) == {2, 1, 3}
    assert Vec3.swizzle({1, 2, 3}, :yzx) == {2, 3, 1}
    assert Vec3.swizzle({1, 2, 3}, :zxy) == {3, 1, 2}
    assert Vec3.swizzle({1, 2, 3}, :zyx) == {3, 2, 1}
  end
  
  test "map" do
    clamp_upper = {1.1, 1.2, 1.3} |> Vec3.map(&(Enum.min([&1, 1.0])))
    assert clamp_upper == {1.0, 1.0, 1.0}
  end

  test "orthogonal vector proof" do
    assert Vec3.cross({1, -7, 1}, {5, 2, 4}) == {-30, 1, 37}
    assert Vec3.dot({-30, 1, 37}, {1, -7, 1}) == 0
    assert Vec3.dot({-30, 1, 37}, {5, 2, 4}) == 0
    ninety_degrees = 1.570796
    assert (Vec3.angle({-30, 1, 37}, {1, -7, 1}, :undefined) |> Float.round(6)) == ninety_degrees
    assert (Vec3.angle({-30, 1, 37}, {5, 2, 4}, :undefined) |> Float.round(6)) == ninety_degrees
  end
  
  test "normalization proof" do
    assert (({3, 10, -3} |> Vec3.normalize |> Vec3.map(&(Float.round(&1, 6))))
            == {0.276172, 0.920575, -0.276172})
    assert ({0.276172, 0.920575, -0.276172} |> Vec3.length |> Float.round(2)) == 1.0
  end
end
